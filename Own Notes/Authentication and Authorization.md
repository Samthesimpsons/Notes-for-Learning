# Authentication & Authorization

## Core Concepts

* **Authentication** → Who are you?
* **Authorization** → What are you allowed to do?

Example:
-   Login to GitHub → Authentication
-   Push to repository → Authorization

------------------------------------------------------------------------

# 1. Authorization Models

Authorization determines **what resources a user can access and what
actions they can perform**.

------------------------------------------------------------------------

# 1.1 RBAC --- Role Based Access Control

Users are assigned **roles**, and roles have **permissions**.

    User → Role → Permissions

### Example: GitHub Repository Permissions

| Role       | Permissions                                  |
|------------|----------------------------------------------|
| Admin      | manage repo, delete repo, manage users       |
| Maintainer | merge PRs, manage issues                     |
| Developer  | push code                                    |
| Viewer     | read repository                              |

### RBAC Flow

```mermaid
flowchart LR
User --> Role
Role --> Permissions
Permissions --> Resource
```

### Real-world systems using RBAC

-   GitHub repository permissions
-   Kubernetes RBAC
-   AWS IAM roles
-   Google Cloud IAM

### Pros

-   Simple to understand
-   Easy to implement

### Cons

-   Role explosion problem
-   Not flexible for complex policies

Example role explosion:

    Engineer_US_ReadOnly
    Engineer_US_Admin
    Engineer_EU_ReadOnly
    Engineer_EU_Admin

------------------------------------------------------------------------

# 1.2 ABAC --- Attribute Based Access Control

Instead of roles, decisions are based on **attributes**.

Attributes can belong to:

-   User
-   Resource
-   Action
-   Environment

### Example Attributes

User:

    department = engineering
    country = singapore
    clearance = level2

Resource:

    classification = internal
    owner = engineering

Environment:

    time = business hours
    location = corporate network

### Example Policy

Allow access if:

    user.department == resource.owner
    AND
    user.clearance >= resource.classification

### ABAC Flow

```mermaid
flowchart LR
UserAttributes --> PolicyEngine
ResourceAttributes --> PolicyEngine
Environment --> PolicyEngine
PolicyEngine --> Decision
Decision --> AllowOrDeny
```

------------------------------------------------------------------------

# 1.3 ACL --- Access Control List

Each **resource stores a list of who can access it**.

    Resource → list of users and permissions

### Example: Google Drive Document

Document: `QuarterlyReport.pdf`

ACL:

    Alice → Editor
    Bob → Viewer
    Charlie → Commenter

### ACL Flow

```mermaid
flowchart LR
User --> Resource
Resource --> ACL
ACL --> PermissionCheck
PermissionCheck --> AllowOrDeny
```

------------------------------------------------------------------------

# 2. Basic Authentication Methods

These methods define **how a user proves their identity**.

------------------------------------------------------------------------

# 2.1 Basic Authentication

Client sends:

    username + password

Encoded using Base64.

Example:

    Authorization: Basic base64(username:password)

Example value:

    Authorization: Basic YWxpY2U6cGFzc3dvcmQ=

### Flow

```mermaid
sequenceDiagram
Client->>Server: Request with username/password
Server->>Database: Verify credentials
Database->>Server: Valid/Invalid
Server->>Client: Access granted/denied
```

------------------------------------------------------------------------

# 2.2 Digest Authentication

Improves security by **sending a hash instead of the password**.

### Flow

```mermaid
sequenceDiagram
Client->>Server: Request resource
Server->>Client: Challenge (nonce)
Client->>Server: Hash(username,password,nonce)
Server->>Server: Verify hash
Server->>Client: Allow or deny
```

------------------------------------------------------------------------

# 2.3 API Keys

Common for **machine-to-machine authentication**.

Example:

    Authorization: ApiKey abc123xyz

Examples:

-   Stripe API
-   OpenAI API
-   Google Maps API

### Flow

```mermaid
sequenceDiagram
Client->>Server: Request with API key
Server->>Database: Validate key
Database->>Server: Valid/Invalid
Server->>Client: Response
```

------------------------------------------------------------------------

# 2.4 Session Authentication

Used in **traditional web applications**.

After login:

    server creates session
    client stores session cookie

### Flow

```mermaid
sequenceDiagram
User->>Server: Login with credentials
Server->>Server: Create session
Server->>User: Session cookie

User->>Server: Request + session cookie
Server->>SessionStore: Validate session
SessionStore->>Server: Valid
Server->>User: Response
```

------------------------------------------------------------------------

# 3. Token‑Based Authentication

Instead of sessions, the server returns a **token**.

Client sends the token with each request.

------------------------------------------------------------------------

# 3.1 Bearer Tokens

Meaning:

    whoever has the token can access the resource

Example:

    Authorization: Bearer <token>

### Flow

```mermaid
sequenceDiagram
User->>AuthServer: Login
AuthServer->>User: Bearer token

User->>API: Request + token
API->>API: Validate token
API->>User: Response
```

------------------------------------------------------------------------

# 3.2 JWT --- JSON Web Token

JWT is a **self‑contained token**.

Structure:

    header.payload.signature

Payload example:

```json
{
  "user_id": 123,
  "role": "admin",
  "exp": 1712345678
}
```

### JWT Flow

```mermaid
sequenceDiagram
User->>AuthServer: Login
AuthServer->>User: JWT token

User->>API: Request + JWT
API->>API: Verify signature
API->>User: Response
```

------------------------------------------------------------------------

# 3.3 Access & Refresh Tokens

Used to avoid **long‑lived tokens**.

### Flow

```mermaid
sequenceDiagram
User->>AuthServer: Login
AuthServer->>User: Access Token + Refresh Token

User->>API: Request + Access Token
API->>User: Response

Note over User,AuthServer: Access token expires

User->>AuthServer: Refresh Token
AuthServer->>User: New Access Token
```

------------------------------------------------------------------------

# 4. Authentication & Authorization Frameworks

------------------------------------------------------------------------

# OAuth2 --- Authorization Framework

Allows applications to access resources **without sharing passwords**.

### OAuth2 Authorization Code Flow

```mermaid
sequenceDiagram
User->>ClientApp: Login with Google
ClientApp->>AuthServer: Redirect user

User->>AuthServer: Login + consent
AuthServer->>ClientApp: Authorization code

ClientApp->>AuthServer: Exchange code
AuthServer->>ClientApp: Access token

ClientApp->>ResourceServer: API request + token
ResourceServer->>ClientApp: Data
```

------------------------------------------------------------------------

# OIDC --- OpenID Connect

OIDC adds **authentication** on top of OAuth2.

OAuth2 → Authorization\
OIDC → Authentication

Returns an **ID Token (JWT)**.

------------------------------------------------------------------------

# SSO --- Single Sign-On

Users log in once and access multiple applications.

An Identity Provider (IdP) is a system responsible for authenticating users and issuing identity information or tokens to applications. Applications trust the IdP instead of implementing authentication themselves.

| Provider        | Example Use                   |
| --------------- | ----------------------------- |
| Okta            | Enterprise SSO                |
| Auth0           | Authentication platform       |
| Azure AD        | Corporate identity management |
| Google Identity | Social login                  |
| AWS Cognito     | Application user pools        |

### SSO Flow

```mermaid
sequenceDiagram
User->>IdP: Login
IdP->>User: Authenticated

User->>ApplicationA: Request
ApplicationA->>IdP: Validate
IdP->>ApplicationA: Valid

User->>ApplicationB: Request
ApplicationB->>IdP: Validate
IdP->>ApplicationB: Valid
```

------------------------------------------------------------------------

# Real System Example --- GitHub OAuth Login

```mermaid
sequenceDiagram
User->>App: Login with GitHub
App->>GitHubOAuth: Redirect

User->>GitHubOAuth: Authenticate
GitHubOAuth->>App: Authorization Code

App->>GitHubOAuth: Exchange Code
GitHubOAuth->>App: Access Token

App->>GitHubAPI: Request user info
GitHubAPI->>App: User profile

App->>App: Create session or JWT
App->>User: Logged in
```

------------------------------------------------------------------------

# Quick Interview Summary with Strength and Limitations

## Authentication Models

| Method                     | Type                  | Strengths                                                                             | Limitations                                                                      | Typical Use Case                     |
| -------------------------- | --------------------- | ------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------- | ------------------------------------ |
| **Basic Auth**             | Credential-based      | Very simple to implement, supported by HTTP standard                                  | Sends credentials every request, requires HTTPS, difficult to revoke credentials | Internal tools, simple APIs          |
| **Digest Auth**            | Challenge-response    | Password not sent directly, slightly more secure than Basic                           | Complex, limited adoption, largely replaced by token-based auth                  | Legacy systems                       |
| **API Keys**               | Token-like credential | Simple for machine-to-machine auth, easy to implement                                 | Hard to rotate, no built-in identity metadata, can be leaked easily              | Public APIs (Stripe, Google Maps)    |
| **Session Authentication** | Stateful              | Easy revocation, secure when cookies are protected, simple for web apps               | Requires session store, difficult to scale across distributed systems            | Traditional server-rendered web apps |
| **Bearer Token**           | Token-based           | Stateless, easy to use in APIs, widely supported                                      | Whoever has token can use it, requires HTTPS, needs expiration management        | REST APIs                            |
| **JWT**                    | Self-contained token  | Stateless, scalable, contains claims (user info, roles), good for distributed systems | Hard to revoke before expiry, larger token size, potential security pitfalls     | Microservices, modern APIs           |


## Authorization Models

| Model                                     | Core Idea                                               | Strengths                                    | Limitations                                                | Example Systems                                |
| ----------------------------------------- | ------------------------------------------------------- | -------------------------------------------- | ---------------------------------------------------------- | ---------------------------------------------- |
| **RBAC** (Role-Based Access Control)      | Permissions assigned to roles, users assigned to roles  | Simple mental model, easy to implement       | Role explosion in large organizations, limited flexibility | GitHub roles, Kubernetes RBAC                  |
| **ABAC** (Attribute-Based Access Control) | Access determined by evaluating attributes and policies | Highly flexible, powerful policy enforcement | Complex policies, harder to debug and maintain             | AWS IAM policies, Google Cloud IAM             |
| **ACL** (Access Control List)             | Resource stores list of users and permissions           | Fine-grained control per resource            | Hard to manage at scale, large permission lists            | Google Drive sharing, Windows file permissions |


## Protocols

| Protocol                  | Purpose                                                                             | Strengths                                               | Limitations                                 | Common Use Cases                |
| ------------------------- | ----------------------------------------------------------------------------------- | ------------------------------------------------------- | ------------------------------------------- | ------------------------------- |
| **OAuth2**                | Authorization framework allowing apps to access resources without sharing passwords | Secure delegated access, widely adopted, flexible flows | Complex to implement correctly              | Login with Google, GitHub OAuth |
| **OIDC (OpenID Connect)** | Authentication layer on top of OAuth2                                               | Standardized identity authentication, returns ID tokens | Requires OAuth2 infrastructure              | Social login, enterprise login  |
| **SSO (Single Sign-On)**  | Allows one login across multiple applications                                       | Improved user experience, centralized authentication    | Depends on identity provider infrastructure | Corporate login systems         |
