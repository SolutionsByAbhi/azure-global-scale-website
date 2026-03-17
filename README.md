# Azure Global Scale Website

A globally scalable website architecture on Azure using:

- Azure Front Door (CDN + global routing)
- Azure Application Gateway with WAF
- Auto-scaling App Service
- Azure Database for PostgreSQL (HA, multi-AZ)
- Azure Cache for Redis
- Azure Monitor / App Insights
- Bicep for Infrastructure as Code
- Next.js 14 for the website

## Deploy Infra

```bash
az group create -n rg-globalweb-prod -l westeurope
az deployment group create \
  -g rg-globalweb-prod \
  -f infra/main.bicep \
  -p infra/parameters/main.parameters.json
