# rasa-heroku-template — Migration Context

## Tech Stack
- **Language**: Python
- **Framework**: Rasa NLU/Core (Open Source Conversational AI framework)
- **Package Manager**: None explicitly defined (uses Rasa Docker image base)
- **Runtime Version**: Latest Rasa Docker image (from `rasa/rasa:latest`)

## Architecture
This is a Rasa NLU (Natural Language Understanding) server template designed for Heroku deployment. The application is a conversational AI bot that can:
- Process natural language text and extract intents
- Handle basic conversational flows (greetings, goodbyes, mood responses)
- Provide REST API endpoints for NLU parsing
- Train and serve a simple chatbot model

Key components:
- **Rasa NLU**: Processes incoming text and classifies intents
- **Training Data**: Basic conversational intents (greet, goodbye, mood responses, bot challenges)
- **REST API**: Exposes `/model/parse` endpoint for NLU processing
- **Docker Container**: Self-contained deployment with pre-trained model

## Modules & Key Files
| File | Purpose |
|---|---|
| `Dockerfile` | Container definition using `rasa/rasa:latest` base |
| `server.sh` | Entry point script that starts Rasa server |
| `app/config.yml` | Rasa configuration (uses defaults) |
| `app/domain.yml` | Defines intents, responses, and session config |
| `app/data/nlu.yml` | Training data with example phrases for each intent |
| `app/data/stories.yml` | Conversation flow definitions |
| `app/data/rules.yml` | Rule-based conversation handling |
| `app/endpoints.yml` | Server endpoint configurations (mostly commented) |
| `app/credentials.yml` | Channel configurations (REST enabled) |
| `app/actions/actions.py` | Custom actions (empty template) |
| `heroku.yml` | Heroku container stack configuration |
| `app.json` | Heroku app deployment metadata |

## Packages
| Package | Old Version | New Version | Notes |
|---|---|---|---|
| rasa/rasa Docker image | latest | 3.6.21 | Latest stable Rasa Open Source (Jan 2025), model breaking change |

## Heroku -> DO Mapping
| Heroku Feature | DO Equivalent | Status |
|---|---|---|
| Container stack (`heroku.yml`) | Dockerfile + App Platform | ✓ Compatible |
| `$PORT` environment variable | App Platform provides `$PORT` | ✓ Compatible |
| Heroku deploy button | Manual deployment via GitHub | ⚠️ Needs .do/app.yaml |
| Auto-scaling | App Platform auto-scaling | ✓ Compatible |

## Environment Variables
### Required
| Variable | Purpose | .env.docker Value | .env.remote Value |
|---|---|---|---|
| PORT | Server port | 8080 | ${PORT} (set by App Platform) |

### Notes
- The application has minimal environment variable dependencies
- No database connections or external service integrations in the base template
- All configuration is file-based through Rasa YAML files

## Test Endpoints
| Endpoint | Method | Expected Status | Expected Response | Notes |
|---|---|---|---|---|
| `/` | GET | 404 | Not Found | Rasa doesn't serve root by default |
| `/model/parse` | POST | 200 | JSON with intent/entities | Main NLU endpoint - `curl -X POST /model/parse -d '{"text":"hello"}'` |
| `/webhooks/rest/webhook` | POST | 200 | JSON response | Conversational endpoint |
| `/status` | GET | 200 | Server status | Health check endpoint |
| `/version` | GET | 200 | Version info | Rasa version endpoint |

## Expected Warnings
- Model loading messages during startup
- Default pipeline/policy warnings (config uses defaults)
- Potential deprecation warnings from Rasa framework

## Local Testing
- **Docker build**: ⚠️ SLOW - Rasa 3.6.21 base image is very large (~1GB+) and training takes several minutes
- **Container port**: 8080
- **Test results**: Build process includes expected warnings (SQLAlchemy, pkg_resources, TensorFlow AVX)

## Remote Deployment
- **App ID**: (Phase B fills this)
- **App URL**: (Phase B fills this)
- **Region**: syd1

## Env Files
- `.env.docker` — Local Docker testing variables
- `.env.remote` — Deployment variables (pushed to GitHub Secrets)

## Observations

### Key Issues Identified:
1. **server.sh syntax error**: ✅ FIXED - Line 3 had `[ -z "$PORT"]` missing space before closing bracket
2. **Default port**: ✅ CHANGED - Changed default from 5005 to 8080 for App Platform compatibility
3. **Unpinned base image**: ✅ FIXED - Pinned to `rasa/rasa:3.6.21` (latest stable)
4. **Broad permissions**: ✅ FIXED - Changed from `chmod -R 777` to `chmod -R 755` for better security
5. **Missing EXPOSE**: ✅ ADDED - Added `EXPOSE 8080` directive to Dockerfile
6. **No package management**: No explicit requirements.txt (acceptable for this Rasa template)

### Migration Considerations:
1. This is a pure Rasa NLU application with no additional dependencies
2. No database or external service integrations
3. Simple REST API server that should work well on App Platform
4. May need to update Rasa version for security and compatibility
5. The training data is minimal but functional for testing

### Rasa Version Analysis:
- Currently uses `rasa/rasa:latest` which could be any version
- Need to pin to specific version for predictability
- Should check for recent Rasa releases for security updates
## Shared Infrastructure

Region: syd1

### MongoDB Cluster
- Cluster ID: 0cd276e1-6800-40f7-b938-72db4e389863
- Host: heroku-migration-mongo-29f7181e.mongo.ondigitalocean.com
- Port: 27017
- Admin User: doadmin
- Admin Password: [REDACTED - Available in shared_infra.env]
- Create app user: `doctl databases user create 0cd276e1-6800-40f7-b938-72db4e389863 <appname>_user`
- Database created on first write (use app-specific name)
- Connection string pattern: Available in .env.remote

### Valkey Cluster
- Cluster ID: ab76d53c-8e07-44ff-b97b-b62815ec66b8
- Host: heroku-migration-valkey-do-user-8198484-0.m.db.ondigitalocean.com
- Port: 25061
- Password: [REDACTED - Available in shared_infra.env]
- Single default user — use key prefix `<appname>:` for data isolation
- Connection string: Available in .env.remote

