#!/bin/sh
curl --fail http://localhost:3000/api/v1/health || exit 1
