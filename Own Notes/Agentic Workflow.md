### Comprehensive Notes: Tool Calling & MCP Protocol in LLMs

---

### **Tool/Function Calling for LLMs**

#### Supported Frameworks

* **CrewAI, LangGraph**: Popular Python frameworks facilitating tool/function calling with LLMs.
* **Purpose**: Allow LLMs to interact with external tools by converting natural language queries into structured function/tool calls.

#### Implementation in LangGraph

* **Decorator-based Approach**:

  * Functions annotated using a tool decorator become callable by the LLM.
  * LLM decision to invoke these functions is based on their descriptive docstrings.

#### Usage & Benefits

* **Expert Agents**:

  * Enables creation of specialized agents, e.g., company research specialists or credit memo experts.
  * Allows agents to interact efficiently with internal or external APIs (e.g., internal search systems, Google Grounding Search).
* **Developer Responsibilities**:

  * Developers must create connectors/tools to facilitate communication between the LLM and the external/internal systems.

---

### **Anthropic’s MCP Protocol**

#### Overview

* **MCP (Multi-Client Protocol)**:

  * A new protocol by Anthropic Claude, standardizing interactions between LLMs and external systems.
  * Allows external platforms (e.g., Notion, Stripe, GitHub) to expose functionalities as MCP-compatible tools.

#### MCP Server & Client

* **External Systems (Notion, GitHub)**:

  * Implement MCP servers providing structured toolsets (update content, read comments, manage tasks).
  * Integration generates an MCP configuration (typically in JSON format).

* **Internal Systems Integration**:

  * Companies can build MCP servers for internal tools widely used within the organization.
  * Developers create a custom `MultiServerMCPClient` using the Python `MCP` package to interface with these servers.

#### Framework Compatibility (e.g., LangGraph)

* LangGraph supports initializing MCP servers.
* Allows LangGraph workflows to interact seamlessly with MCP servers via MCP clients.
* Enables sophisticated integrations within company workflows, leveraging tools exposed via MCP.

#### Pros & Cons

* **Advantages**:

  * Standardized and reusable integration across systems.
  * Scalable solution beneficial for widely adopted internal tools or popular external systems (like Notion).

* **Disadvantages**:

  * High initial development overhead for infrequently used internal systems.
  * Potential inefficiency if the MCP approach is implemented for niche or rarely-used internal tools—simpler direct API integration may be preferable.

---

### **Additional Frameworks**

#### Agent Development Kit (ADK)

* **Purpose**: Framework for building custom AI agents quickly.
* **Features**:

  * Simplifies agent lifecycle management (creation, testing, deployment).
  * Provides pre-built tools and integrations for rapid prototyping.
  * Supports extensive customization and scalability.

#### Dify

* **Purpose**: Platform enabling streamlined deployment of LLM-powered applications.
* **Features**:

  * User-friendly, low-code/no-code environment for building AI apps.
  * Offers built-in integrations with popular external APIs.
  * Facilitates seamless workflow automation and management.

#### AutogenStudio

* **Purpose**: Toolkit for automating the creation and orchestration of complex AI agent workflows.
* **Features**:

  * Visual interface for workflow design and management.
  * Integrates various AI models and tools for comprehensive workflows.
  * Automates monitoring, deployment, and iterative improvement.

#### N8N

* **Purpose**: Open-source automation platform for creating complex workflows with minimal coding.
* **Features**:

  * Offers extensive library of integrations with external applications and services.
  * Enables drag-and-drop workflow creation and management.
  * Supports custom integrations and workflows through easy scripting and APIs.

---

### **Summary of Key Points**

* **Tool/Function Calling** streamlines interaction between LLMs and external/internal systems.
* **Anthropic MCP Protocol** sets standards for tool integration, enabling efficient interaction between LLMs and widely used systems.
* Frameworks like CrewAI and LangGraph facilitate easy integration, but developers must balance complexity and scalability based on tool adoption within organizations.
* New frameworks like ADK, Dify, AutogenStudio, and N8N offer versatile tools for rapid development, automation, and deployment of AI-driven applications and workflows.
