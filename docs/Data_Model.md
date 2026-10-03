# Data Model

## Objects

### Customer

Stores customer information.

### Policy Type

Stores different insurance categories.

### Insurance Policy

Stores policy information and connects customers, policy types and agents.

### Claim

Stores insurance claim information.

### Insurance Agent

Stores insurance agent information.

### Payment

Stores premium payment information.

### Claim Document

Stores supporting claim document information.

## Relationships

Customer → Insurance Policy

Customer → Claim

Customer → Payment

Policy Type → Insurance Policy

Insurance Agent → Insurance Policy

Insurance Policy → Claim

Claim → Claim Document
