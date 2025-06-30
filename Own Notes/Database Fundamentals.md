# Database Fundamentals

## What is a Database?

* Structured collection of data stored in a computer system.
* **DBMS (Database Management System)**:

  * Interacts with the database to:

    * Query (retrieve) data
    * Insert, update, delete data
    * Organize data storage
* **Types**:

  * **Simple**: File-based (text files, spreadsheets)
  * **Complex**: Multi-table systems with billions of records
* Most common: **Relational Databases**

---

## Relational Databases (RDBMS)

* Store data in **tables (columns = fields, rows = records)**.
* Each table represents a single entity (e.g., Customers, Orders).
* Tables connected through:

  * **Primary Key (PK)**: Uniquely identifies a record.
  * **Foreign Key (FK)**: References a PK in another table.
* Allow efficient cross-referencing and complex queries using **SQL**.

---

## RDBMS Features

* CRUD management.
* Enforces:

  * Data types & constraints
  * Query optimization
  * Data consistency & security
* Includes:

  * Transaction management
  * Concurrency control
  * User permissions
  * Backup & recovery
* **Examples**: MySQL, PostgreSQL, Oracle, SQL Server, SQLite

---

## SQL: Structured Query Language

* Standard for accessing and manipulating relational databases.
* Portable across most RDBMS.
* **Types of Commands**:

  * **DDL**: Data Definition (`CREATE`, `ALTER`)
  * **DML**: Data Manipulation (`SELECT`, `INSERT`, `UPDATE`, `DELETE`)
  * **DCL**: Data Control (`GRANT`, `REVOKE`)
  * **TCL**: Transaction Control (`COMMIT`, `ROLLBACK`)
* **Declarative**: Specify *what* you want, not *how*.

---

## Naming Conventions

* Use **descriptive names** (e.g., `last_name`, `Orders`).
* Avoid reserved words (use `Orders`, not `Order`).
* Use **alphanumeric + underscores** only.
* Consistency:

  * Use either `snake_case` or `CamelCase`.
  * Be consistent with singular/plural.
* Keys:

  * PK: `id` or `table_name_id` (e.g., `employee_id`)
  * FK: `referenced_table_id` (e.g., `department_id`)

---

## Database Design Process

1. Identify **entities** and **attributes** (e.g., Books → title, ISBN).
2. Determine **relationships** (1\:N, M\:N).
3. Define **tables and keys**.
4. Apply **normalization** (1NF, 2NF, 3NF) to reduce redundancy.
5. Specify **data types & constraints** (`NOT NULL`, `UNIQUE`, `CHECK`).
6. Result: Schema or ER diagram.

---

## Data Integrity

Ensures data is accurate, consistent, and reliable.

* **Entity Integrity**:

  * PK must be unique & not null.
* **Referential Integrity**:

  * FK values must match a valid PK.
* **Domain Integrity**:

  * Enforced through:

    * Data types
    * Constraints (`NOT NULL`, `CHECK`, `UNIQUE`)
    * Lookup tables

---

**Example:**

```sql
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount >= 0)
);

ALTER TABLE orders
ADD FOREIGN KEY (customer_id) REFERENCES customers(customer_id);
```

---

## Key Database Terms

* **Table**: Rows + columns collection.
* **Row (Record/Tuple)**: Single data entry.
* **Column (Field/Attribute)**: Describes one aspect of records.
* **Primary Key (PK)**: Unique, not null.
* **Foreign Key (FK)**: References PK in another table.
* **Schema**: Database blueprint.
* **Index**: Speeds retrieval.
* **View**: Virtual table from a query.
* **Stored Procedure**: Precompiled SQL routine.
* **Trigger**: Executes on table events.
* **Constraint**: Enforces valid data.
* **Normalization**: Reduces redundancy.
* **Denormalization**: Adds redundancy for read performance.
* **Transaction**: Group of operations (ACID).
* **Query**: Data retrieval command.
* **Query Optimizer**: Selects efficient execution plan.

---

## Atomic Values

* **Atomic value**: Cannot be further divided.
* Required for **1NF** (no lists/groups in fields).
* **Benefits**:

  * Easier querying/filtering/sorting
  * Better integrity & indexing

**Examples**:

* `first_name = 'John', last_name = 'Doe'`
* Normalize phone numbers into separate table.
* Split addresses into components.

---

## Relationships in Databases

### Types:

* **One-to-One (1:1)**: e.g., Person ↔ Passport.
* **One-to-Many (1\:N)**: e.g., Customer → Orders.
* **Many-to-Many (M\:N)**:

  * Requires a junction table (e.g., Students ↔ Courses).

### Design Tips:

* Use FKs to enforce relationships.
* Use cascading actions (`ON DELETE`, `ON UPDATE`).
* Index FKs for query performance.

**Parent Table**: Referenced (e.g., Orders).
**Child Table**: Holds FK (e.g., OrderItems).

---

## Keys in Relational Databases

### Types:

* **Primary Key**: Unique, not null.
* **Foreign Key**: References PK in another table.
* **Candidate Key**: Columns that could be PKs.
* **Alternate Key**: Candidate key not chosen as PK.
* **Composite Key**: Multiple columns as PK.
* **Surrogate Key**: System-generated (`AUTO_INCREMENT`).
* **Natural Key**: Real-world value (e.g., SSN).

### Best Practices:

* Prefer **surrogate keys** for simplicity.
* Use **natural keys** only if stable/meaningful.
* Index PKs and frequently queried FKs.
* Make FKs `NOT NULL` if required; allow `NULL` if optional.

---

## Schema Modeling & Lookup Tables

* **Lookup Tables**: Store valid values (e.g., `status`, `country`).
* **Join Tables (Junction Tables)**: For M\:N relationships using composite PKs of FKs.
* **Normalize for integrity**, denormalize for performance only when necessary.

---

## Referential Integrity, Indexing, and Cascades

* Use FK constraints for valid references.
* Use `CASCADE`, `SET NULL`, `RESTRICT` for update/delete actions.
* Index FKs manually if used in joins or `WHERE` clauses.
* Match `NULL` and constraints to business rules.

---

## Example: Order System Schema

* **Customers**: `customer_id (PK)`
* **Products**: `product_id (PK)`
* **Orders**:

  * `order_id (PK)`
  * `customer_id (FK, NOT NULL)`
  * `status_id (FK to OrderStatus)`
* **OrderItems**:

  * Composite PK: `(order_id, product_id)`
  * FKs to Orders and Products.
* **OrderStatus**: Lookup table for states.
* **Addresses**: Optional FK from Orders to Addresses.

---
