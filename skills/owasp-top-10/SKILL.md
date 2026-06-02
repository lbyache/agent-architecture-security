---
name: owasp-top-10
description: Referencia completa de las 10 vulnerabilidades de seguridad más críticas según OWASP Top 10 2021. Usar cuando se necesita consultar patrones de detección y remediación, realizar auditorías de seguridad, implementar prácticas de código seguro, o revisar código existente en busca de vulnerabilidades comunes. Ver "Cuándo usar este skill" para escenarios.
keywords:
  - CSRF
  - OWASP
  - SQL injection
  - XSS
  - authentication failure
  - broken access control
  - cryptographic failure
  - injection
  - security audit
  - security vulnerability
file_patterns:
  - '**/*secret*.py'
  - '**/*secret*.ts'
  - '**/auth/**'
  - '**/security/**'
confidence: 0.9
---

# OWASP Top 10 — Vulnerabilidades de Seguridad

Guía experta para identificar, prevenir y remediar los riesgos de seguridad más críticos en aplicaciones web, basada en OWASP Top 10 2021.

## Cuándo usar este skill

- Realizar auditorías de seguridad y revisiones de código
- Implementar prácticas de código seguro en nuevas funcionalidades
- Revisar sistemas de autenticación y autorización
- Evaluar validación y sanitización de inputs
- Evaluar dependencias de terceros en busca de vulnerabilidades
- Diseñar controles de seguridad y estrategias de defensa en profundidad
- Preparar certificaciones o auditorías de compliance
- Investigar incidentes de seguridad o comportamiento sospechoso

## OWASP Top 10 2021

**Ordenadas por severidad de riesgo:**

1. **A01** — Broken Access Control (↑ desde #5)
2. **A02** — Cryptographic Failures (antes: Sensitive Data Exposure)
3. **A03** — Injection (↓ desde #1)
4. **A04** — Insecure Design (NUEVA)
5. **A05** — Security Misconfiguration
6. **A06** — Vulnerable and Outdated Components
7. **A07** — Identification and Authentication Failures
8. **A08** — Software and Data Integrity Failures (NUEVA)
9. **A09** — Security Logging and Monitoring Failures
10. **A10** — Server-Side Request Forgery / SSRF (NUEVA)

## Referencia Rápida

Cargar guía detallada por cada vulnerabilidad:

| Vulnerabilidad | Archivo de referencia |
|---|---|
| **Broken Access Control** | `references/broken-access-control.md` |
| **Cryptographic Failures** | `references/cryptographic-failures.md` |
| **Injection** | `references/injection.md` |
| **Insecure Design** | `references/insecure-design.md` |
| **Security Misconfiguration** | `references/security-misconfiguration.md` |
| **Vulnerable Components** | `references/vulnerable-components.md` |
| **Authentication Failures** | `references/authentication-failures.md` |
| **Integrity Failures** | `references/integrity-failures.md` |
| **Logging & Monitoring** | `references/logging-monitoring.md` |
| **SSRF** | `references/ssrf.md` |
| **Estrategias de prevención** | `references/prevention-strategies.md` |
| **Workflow de evaluación** | `references/assessment-workflow.md` |

## Workflow de Auditoría de Seguridad

1. **Identificar alcance**: Determinar componentes de la aplicación y superficie de ataque
2. **Seleccionar vulnerabilidades**: Elegir categorías OWASP relevantes según funcionalidades
3. **Cargar referencia**: Leer archivo(s) de referencia correspondientes para patrones detallados
4. **Analizar código**: Revisar código contra patrones vulnerables y seguros
5. **Documentar hallazgos**: Registrar vulnerabilidades con severidad y remediación
6. **Verificar correcciones**: Comprobar que las remediaciones resuelven los problemas
7. **Testear seguridad**: Ejecutar testing automatizado (SAST, DAST, SCA)

## Principios Fundamentales de Seguridad

### Defensa en profundidad
- Aplicar controles de seguridad en capas: red, aplicación, datos, y monitoreo
- Asegurar que la falla de un control no comprometa todo el sistema

### Seguro por defecto
- Denegar todo acceso por defecto, otorgar permisos explícitamente
- Fallar de forma segura (los errores no exponen información sensible)
- Minimizar la superficie de ataque (deshabilitar funcionalidades no usadas)
- Aplicar principio de mínimo privilegio en todas las cuentas y servicios

### Validación de Inputs
- Validar tipo, longitud, formato, y valores permitidos
- Usar allow-lists en vez de deny-lists
- Sanitizar según el contexto específico (SQL, HTML, shell, etc.)
- Nunca confiar en input del cliente

## Errores Comunes

1. **Confiar en el input del usuario**: Siempre validar y sanitizar toda data del usuario
2. **Implementar criptografía propia**: Usar bibliotecas establecidas (bcrypt, AES-256)
3. **Exponer errores**: Loguear errores detallados internamente, mostrar mensajes genéricos al usuario
4. **Omitir autorización**: Verificar permisos en cada request, no solo en la UI
5. **Gestión débil de sesiones**: Usar cookies secure, httpOnly, sameSite con HTTPS
6. **Ignorar dependencias**: Auditar y actualizar regularmente bibliotecas de terceros
7. **Sin logging**: Loguear eventos de seguridad para detección y respuesta a incidentes
8. **Configuraciones por defecto**: Hardening en todos los sistemas, deshabilitar defaults

## Herramientas de Testing de Seguridad

**SAST (Estático)**: SonarQube, Semgrep, ESLint security plugins
**DAST (Dinámico)**: OWASP ZAP, Burp Suite
**SCA (Dependencias)**: npm audit, Snyk, Dependabot
**Escaneo de secrets**: GitGuardian, TruffleHog
**Penetration Testing**: Metasploit, Kali Linux tools

## Recursos

- **OWASP Top 10 2021**: https://owasp.org/Top10/
- **OWASP Cheat Sheets**: https://cheatsheetseries.owasp.org/
- **OWASP ASVS**: Application Security Verification Standard
- **CWE Top 25**: Common Weakness Enumeration
- **NIST Cybersecurity Framework**: https://www.nist.gov/cyberframework
- **CVE Database**: https://cve.mitre.org/
- **Snyk Vulnerability DB**: https://snyk.io/vuln/
