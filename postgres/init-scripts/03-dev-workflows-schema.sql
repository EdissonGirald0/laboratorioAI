-- Tablas para workflows de desarrollo de software
-- Ejecutar en PostgreSQL (base de datos: ailab)

-- Tabla para revisiones de código
CREATE TABLE IF NOT EXISTS code_reviews (
    id SERIAL PRIMARY KEY,
    language VARCHAR(50) NOT NULL,
    review TEXT NOT NULL,
    severity VARCHAR(20) DEFAULT 'medium',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_code_reviews_severity ON code_reviews(severity);
CREATE INDEX idx_code_reviews_created_at ON code_reviews(created_at DESC);

-- Tabla para mensajes de commit
CREATE TABLE IF NOT EXISTS git_commits (
    id SERIAL PRIMARY KEY,
    type VARCHAR(20) NOT NULL,
    scope VARCHAR(50),
    description TEXT NOT NULL,
    body TEXT,
    has_breaking_changes BOOLEAN DEFAULT FALSE,
    commit_message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_git_commits_type ON git_commits(type);
CREATE INDEX idx_git_commits_breaking ON git_commits(has_breaking_changes) WHERE has_breaking_changes = TRUE;
CREATE INDEX idx_git_commits_created_at ON git_commits(created_at DESC);

-- Tabla para reportes de bugs
CREATE TABLE IF NOT EXISTS bug_reports (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    analysis TEXT NOT NULL,
    severity VARCHAR(20) NOT NULL,
    category VARCHAR(50) NOT NULL,
    estimated_hours INTEGER DEFAULT 4,
    priority VARCHAR(20) DEFAULT 'media',
    score INTEGER DEFAULT 5,
    status VARCHAR(20) DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    resolved_at TIMESTAMP
);

CREATE INDEX idx_bug_reports_severity ON bug_reports(severity);
CREATE INDEX idx_bug_reports_status ON bug_reports(status);
CREATE INDEX idx_bug_reports_category ON bug_reports(category);
CREATE INDEX idx_bug_reports_priority ON bug_reports(priority);
CREATE INDEX idx_bug_reports_score ON bug_reports(score DESC);

-- Tabla para documentación de API
CREATE TABLE IF NOT EXISTS api_documentation (
    id SERIAL PRIMARY KEY,
    method VARCHAR(10) NOT NULL,
    path VARCHAR(255) NOT NULL,
    documentation TEXT NOT NULL,
    openapi_spec JSONB,
    version VARCHAR(20) DEFAULT '3.0.0',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(method, path)
);

CREATE INDEX idx_api_docs_method ON api_documentation(method);
CREATE INDEX idx_api_docs_path ON api_documentation(path);
CREATE INDEX idx_api_docs_spec ON api_documentation USING GIN(openapi_spec);

-- Tabla para tests generados
CREATE TABLE IF NOT EXISTS generated_tests (
    id SERIAL PRIMARY KEY,
    language VARCHAR(50) NOT NULL,
    test_framework VARCHAR(50) NOT NULL,
    test_code TEXT NOT NULL,
    test_count INTEGER DEFAULT 0,
    has_unit_tests BOOLEAN DEFAULT TRUE,
    has_integration_tests BOOLEAN DEFAULT FALSE,
    has_mocks BOOLEAN DEFAULT FALSE,
    estimated_coverage INTEGER DEFAULT 75,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_generated_tests_language ON generated_tests(language);
CREATE INDEX idx_generated_tests_framework ON generated_tests(test_framework);
CREATE INDEX idx_generated_tests_coverage ON generated_tests(estimated_coverage DESC);

-- Vista de resumen de bugs
CREATE OR REPLACE VIEW bug_summary AS
SELECT 
    severity,
    category,
    status,
    COUNT(*) as total,
    AVG(estimated_hours) as avg_hours,
    AVG(score) as avg_score
FROM bug_reports
GROUP BY severity, category, status;

-- Vista de tipos de commits
CREATE OR REPLACE VIEW commit_stats AS
SELECT 
    type,
    COUNT(*) as total,
    COUNT(CASE WHEN has_breaking_changes THEN 1 END) as breaking_changes,
    DATE_TRUNC('day', created_at) as date
FROM git_commits
GROUP BY type, DATE_TRUNC('day', created_at)
ORDER BY date DESC;

-- Vista de cobertura de tests
CREATE OR REPLACE VIEW test_coverage_stats AS
SELECT 
    language,
    test_framework,
    COUNT(*) as total_tests,
    AVG(test_count) as avg_test_count,
    AVG(estimated_coverage) as avg_coverage,
    SUM(CASE WHEN has_unit_tests THEN 1 ELSE 0 END) as with_unit_tests,
    SUM(CASE WHEN has_integration_tests THEN 1 ELSE 0 END) as with_integration_tests
FROM generated_tests
GROUP BY language, test_framework;

-- Función para actualizar updated_at automáticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers para updated_at
CREATE TRIGGER update_code_reviews_updated_at
    BEFORE UPDATE ON code_reviews
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_bug_reports_updated_at
    BEFORE UPDATE ON bug_reports
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_api_documentation_updated_at
    BEFORE UPDATE ON api_documentation
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Comentarios en tablas
COMMENT ON TABLE code_reviews IS 'Almacena revisiones de código generadas por IA';
COMMENT ON TABLE git_commits IS 'Almacena mensajes de commit generados automáticamente';
COMMENT ON TABLE bug_reports IS 'Almacena análisis de reportes de bugs';
COMMENT ON TABLE api_documentation IS 'Almacena documentación de API generada';
COMMENT ON TABLE generated_tests IS 'Almacena tests unitarios generados por IA';

-- Datos de ejemplo (opcional)
-- INSERT INTO code_reviews (language, review, severity) 
-- VALUES ('javascript', 'Código bien estructurado...', 'low');
