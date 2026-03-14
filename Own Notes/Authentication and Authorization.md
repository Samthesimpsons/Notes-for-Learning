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

# 4.1 OAuth2 --- Authorization Framework

OAuth2 is an **authorization framework** that allows applications to
access resources **without sharing user passwords**.

Instead of giving credentials to third-party applications, users grant
**limited access via tokens**.

Common OAuth roles:

  Role                   Description
  ---------------------- ---------------------------------
  Resource Owner         The user who owns the data
  Client                 Application requesting access
  Authorization Server   Issues tokens
  Resource Server        API hosting protected resources

## OAuth2 Authorization Code Flow

``` mermaid
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

# 4.2 OIDC --- OpenID Connect

OIDC is an **authentication layer built on top of OAuth2**.

OAuth2 → Authorization\
OIDC → Authentication

OIDC returns an **ID Token (JWT)** containing user identity.

Example:

``` json
{
  "sub": "123456",
  "name": "Samuel Sim",
  "email": "samuel@example.com",
  "iss": "https://accounts.google.com",
  "exp": 1712345678
}
```

------------------------------------------------------------------------

# 4.3 SSO --- Single Sign-On

Users log in **once** and access multiple applications.

An **Identity Provider (IdP)** authenticates users and issues tokens or
assertions trusted by applications.

Applications rely on the IdP instead of implementing authentication.

Common providers:

  Provider          Example Use
  ----------------- -------------------------------
  Okta              Enterprise SSO
  Auth0             Authentication platform
  Azure AD          Corporate identity management
  Google Identity   Social login
  AWS Cognito       Application user pools

## SSO Flow

``` mermaid
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

# 4.4 SAML --- Security Assertion Markup Language

SAML is an **XML-based authentication protocol used for enterprise
SSO**.

It allows applications to **delegate authentication to an Identity
Provider**.

Core Components:

  Component                 Description
  ------------------------- ---------------------------------------
  Identity Provider (IdP)   Authenticates the user
  Service Provider (SP)     Application requesting authentication
  SAML Assertion            XML document proving authentication

### SAML Authentication Flow

``` mermaid
sequenceDiagram
User->>ServiceProvider: Request login
ServiceProvider->>IdentityProvider: Redirect user

User->>IdentityProvider: Authenticate
IdentityProvider->>ServiceProvider: SAML Assertion

ServiceProvider->>User: Access granted
```

### Characteristics

  Feature          Description
  ---------------- ----------------------------------
  Format           XML
  Primary use      Enterprise SSO
  Common systems   Okta, Azure AD, Google Workspace

------------------------------------------------------------------------

# 4.5 Kerberos --- Ticket-Based Authentication Protocol

Kerberos is a **network authentication protocol using tickets and
symmetric cryptography**.

Instead of repeatedly sending passwords across the network, Kerberos
issues **time-limited authentication tickets**.

Key Components:

  Component        Description
  ---------------- ----------------------------
  Client           User requesting access
  KDC              Key Distribution Center
  AS               Authentication Server
  TGS              Ticket Granting Server
  Service Server   Application being accessed

KDC = **AS + TGS**

## Kerberos Authentication Flow

``` mermaid
sequenceDiagram
Client->>AS: Authentication request
AS->>Client: Ticket Granting Ticket (TGT)

Client->>TGS: Request service ticket
TGS->>Client: Service Ticket

Client->>Service: Request with ticket
Service->>Client: Access granted
```

Key Concepts:

  Concept         Explanation
  --------------- ------------------------------
  Ticket          Proof of authentication
  Session Key     Temporary encryption key
  Authenticator   Prevents replay attacks
  Time Sync       Requires synchronized clocks

### Typical Usage

-   Microsoft Active Directory
-   Hadoop clusters
-   Enterprise SSO systems

------------------------------------------------------------------------

# 4.6 LDAP --- Lightweight Directory Access Protocol

LDAP is a **protocol used to access and manage directory services**.

A directory stores identity information such as:

-   users
-   groups
-   roles
-   permissions
-   devices

LDAP often acts as the **central identity database**.

## Directory Structure

LDAP stores data in a hierarchical structure called the **Directory
Information Tree (DIT)**.

Example:

    dc=company,dc=com
     ├── ou=engineering
     │   ├── uid=samuel
     │   ├── uid=alice
     │
     ├── ou=hr
         ├── uid=bob

## LDAP Authentication Flow

``` mermaid
sequenceDiagram
User->>Application: Login
Application->>LDAPServer: Bind request
LDAPServer->>LDAPServer: Validate credentials
LDAPServer->>Application: Valid / Invalid
Application->>User: Access granted / denied
```

## LDAP Operations

  Operation   Description
  ----------- ---------------------------
  Bind        Authenticate to directory
  Search      Query directory entries
  Add         Create new entry
  Modify      Update entry
  Delete      Remove entry

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

| Protocol / System                                | Purpose                                                                                                                  | Strengths                                                                                     | Limitations                                                                                          | Common Use Cases                                                     |
| ------------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------- |
| **OAuth2**                                       | Authorization framework allowing apps to access resources without sharing passwords                                      | Secure delegated access, widely adopted, flexible flows                                       | Complex to implement correctly; not authentication by itself                                         | Login with Google, GitHub OAuth, API access delegation               |
| **OIDC (OpenID Connect)**                        | Authentication layer built on top of OAuth2 that provides identity verification                                          | Standardized authentication, returns ID tokens (JWT), modern web/mobile friendly              | Requires OAuth2 infrastructure; slightly more complex setup                                          | Social login, enterprise identity providers, modern SaaS apps        |
| **SSO (Single Sign-On)**                         | Allows users to authenticate once and access multiple applications                                                       | Improved user experience, centralized authentication management                               | Depends on identity provider infrastructure; single point of failure if poorly designed              | Corporate login systems, enterprise portals                          |
| **Kerberos**                                     | Network authentication protocol using tickets and symmetric-key cryptography                                             | Strong mutual authentication, password not sent over network, efficient for internal networks | Complex setup, tightly coupled with domain infrastructure, weaker for internet-facing apps           | Windows Active Directory authentication, internal enterprise systems |
| **SAML (Security Assertion Markup Language)**    | XML-based protocol for exchanging authentication and authorization data between identity providers and service providers | Mature enterprise standard, strong federation support, widely used by enterprises             | XML-heavy, complex to configure/debug, not ideal for mobile or modern APIs                           | Enterprise SSO (Okta, Azure AD, ADFS), SaaS integrations             |
| **LDAP (Lightweight Directory Access Protocol)** | Protocol for accessing and maintaining distributed directory services (users, groups, credentials)                       | Centralized directory, efficient querying, widely supported by enterprise systems             | Not an authentication protocol by itself; requires additional mechanisms (e.g., bind authentication) | Corporate directories, Active Directory, user management systems     |

