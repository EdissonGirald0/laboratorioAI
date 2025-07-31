-- Esquemas adicionales para el sistema de monitoreo y alertas
-- Ejecutar después de que PostgreSQL esté disponible

-- Tabla para logs de salud del sistema
CREATE TABLE IF NOT EXISTS system_health_logs (
    id SERIAL PRIMARY KEY,
    check_id VARCHAR(255) UNIQUE NOT NULL,
    overall_health VARCHAR(20) NOT NULL DEFAULT 'unknown',
    healthy_services INTEGER DEFAULT 0,
    total_services INTEGER DEFAULT 0,
    health_percentage INTEGER DEFAULT 0,
    service_details JSONB DEFAULT '{}'::jsonb,
    check_duration_ms INTEGER DEFAULT 0,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para optimizar consultas de monitoreo
CREATE INDEX IF NOT EXISTS idx_system_health_logs_timestamp ON system_health_logs(timestamp);
CREATE INDEX IF NOT EXISTS idx_system_health_logs_health ON system_health_logs(overall_health);
CREATE INDEX IF NOT EXISTS idx_system_health_logs_percentage ON system_health_logs(health_percentage);

-- Tabla para alertas del sistema
CREATE TABLE IF NOT EXISTS system_alerts (
    id SERIAL PRIMARY KEY,
    alert_id VARCHAR(255) UNIQUE NOT NULL,
    severity VARCHAR(20) NOT NULL DEFAULT 'info',
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    details JSONB DEFAULT '{}'::jsonb,
    recommended_actions JSONB DEFAULT '[]'::jsonb,
    status VARCHAR(20) DEFAULT 'open',
    resolved_at TIMESTAMP WITH TIME ZONE,
    resolved_by VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para alertas
CREATE INDEX IF NOT EXISTS idx_system_alerts_severity ON system_alerts(severity);
CREATE INDEX IF NOT EXISTS idx_system_alerts_status ON system_alerts(status);
CREATE INDEX IF NOT EXISTS idx_system_alerts_created ON system_alerts(created_at);

-- Tabla para métricas de rendimiento
CREATE TABLE IF NOT EXISTS performance_metrics (
    id SERIAL PRIMARY KEY,
    metric_id VARCHAR(255) UNIQUE NOT NULL,
    service_name VARCHAR(100) NOT NULL,
    metric_type VARCHAR(50) NOT NULL,
    metric_value DECIMAL(15,6) NOT NULL,
    unit VARCHAR(20) DEFAULT '',
    metadata JSONB DEFAULT '{}'::jsonb,
    timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Índices para métricas
CREATE INDEX IF NOT EXISTS idx_performance_metrics_service ON performance_metrics(service_name);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_type ON performance_metrics(metric_type);
CREATE INDEX IF NOT EXISTS idx_performance_metrics_timestamp ON performance_metrics(timestamp);

-- Vista para el dashboard de salud
CREATE OR REPLACE VIEW health_dashboard AS
SELECT 
    shl.overall_health,
    shl.health_percentage,
    shl.healthy_services,
    shl.total_services,
    shl.timestamp as last_check,
    COUNT(sa.id) as open_alerts,
    COUNT(CASE WHEN sa.severity = 'critical' THEN 1 END) as critical_alerts
FROM system_health_logs shl
LEFT JOIN system_alerts sa ON sa.status = 'open' AND sa.created_at >= shl.timestamp - INTERVAL '1 hour'
WHERE shl.timestamp = (SELECT MAX(timestamp) FROM system_health_logs)
GROUP BY shl.id, shl.overall_health, shl.health_percentage, shl.healthy_services, shl.total_services, shl.timestamp;

-- Vista para tendencias de salud (últimas 24 horas)
CREATE OR REPLACE VIEW health_trends AS
SELECT 
    DATE_TRUNC('hour', timestamp) as hour,
    AVG(health_percentage) as avg_health_percentage,
    MIN(health_percentage) as min_health_percentage,
    MAX(health_percentage) as max_health_percentage,
    COUNT(*) as check_count
FROM system_health_logs 
WHERE timestamp >= NOW() - INTERVAL '24 hours'
GROUP BY DATE_TRUNC('hour', timestamp)
ORDER BY hour;

-- Función para limpiar logs antiguos (mantener solo 30 días)
CREATE OR REPLACE FUNCTION cleanup_old_health_logs() 
RETURNS INTEGER AS $$
DECLARE
    deleted_count INTEGER;
BEGIN
    DELETE FROM system_health_logs 
    WHERE created_at < NOW() - INTERVAL '30 days';
    
    GET DIAGNOSTICS deleted_count = ROW_COUNT;
    RETURN deleted_count;
END;
$$ LANGUAGE plpgsql;

-- Función para obtener servicios problemáticos
CREATE OR REPLACE FUNCTION get_problematic_services(check_period INTERVAL DEFAULT '1 hour') 
RETURNS TABLE(
    service_name TEXT,
    failure_count BIGINT,
    last_failure TIMESTAMP WITH TIME ZONE,
    failure_rate DECIMAL
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        service_details_expanded.key::TEXT as service_name,
        COUNT(*) as failure_count,
        MAX(shl.timestamp) as last_failure,
        ROUND(COUNT(*)::DECIMAL / 
              (EXTRACT(EPOCH FROM check_period) / 300)::DECIMAL * 100, 2) as failure_rate
    FROM system_health_logs shl,
         LATERAL jsonb_each(shl.service_details) as service_details_expanded
    WHERE shl.timestamp >= NOW() - check_period
      AND (service_details_expanded.value->>'status')::TEXT != 'healthy'
    GROUP BY service_details_expanded.key
    ORDER BY failure_count DESC;
END;
$$ LANGUAGE plpgsql;

-- Insertar datos de ejemplo para testing
INSERT INTO system_health_logs (check_id, overall_health, healthy_services, total_services, health_percentage, service_details, check_duration_ms, timestamp)
VALUES 
    ('health_init_1', 'healthy', 5, 5, 100, '{"postgres": {"status": "healthy"}, "redis": {"status": "healthy"}, "qdrant": {"status": "healthy"}, "ollama": {"status": "healthy"}, "openwebui": {"status": "healthy"}}', 1500, NOW())
ON CONFLICT (check_id) DO NOTHING;

-- Comentarios de documentación
COMMENT ON TABLE system_health_logs IS 'Registros de monitoreo de salud del sistema cada 5 minutos';
COMMENT ON TABLE system_alerts IS 'Alertas del sistema generadas automáticamente por problemas detectados';
COMMENT ON TABLE performance_metrics IS 'Métricas de rendimiento de servicios individuales';
COMMENT ON VIEW health_dashboard IS 'Vista consolidada del estado actual del sistema';
COMMENT ON VIEW health_trends IS 'Tendencias de salud del sistema en las últimas 24 horas';
