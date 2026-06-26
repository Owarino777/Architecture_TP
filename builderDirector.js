"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
// 1. Produit : la requête SQL finale
class SqlQuery {
    query;
    constructor(query) {
        this.query = query;
    }
    getSql() {
        return this.query;
    }
}
// 3. Monteur concret : construit une requête dans un dialecte précis
class StandardSqlQueryBuilder {
    queryType = "";
    table = "";
    columns = [];
    values = [];
    assignments = [];
    condition = "";
    constructor() {
        this.reset();
    }
    reset() {
        this.queryType = "";
        this.table = "";
        this.columns = [];
        this.values = [];
        this.assignments = [];
        this.condition = "";
    }
    setSelect() {
        this.queryType = "SELECT";
    }
    setUpdate() {
        this.queryType = "UPDATE";
    }
    setDelete() {
        this.queryType = "DELETE";
    }
    setInsert() {
        this.queryType = "INSERT";
    }
    setTable(table) {
        this.table = table;
    }
    setColumns(columns) {
        this.columns = columns;
    }
    setValues(values) {
        this.values = values;
    }
    setAssignments(values) {
        this.assignments = values;
    }
    setWhere(condition) {
        this.condition = condition;
    }
    getResult() {
        let query = "";
        switch (this.queryType) {
            case "SELECT":
                query = 'SELECT ' + this.columns.join(", ") + ' FROM ' + this.table;
                if (this.condition) {
                    query += ' WHERE ' + this.condition;
                }
                break;
            case "UPDATE":
                query = 'UPDATE ' + this.table + ' SET ' + this.assignments.join(", ");
                if (this.condition) {
                    query += ' WHERE ' + this.condition;
                }
                break;
            case "DELETE":
                query = 'DELETE FROM ' + this.table;
                if (this.condition) {
                    query += ' WHERE ' + this.condition;
                }
                break;
            case "INSERT":
                query = 'INSERT INTO ' + this.table + ' (' + this.columns.join(", ") + ') VALUES (' + this.values.join(", ") + ')';
                break;
        }
        return new SqlQuery(query);
    }
}
// 4. Directeur : appelle les étapes dans le bon ordre
class SqlQueryDirector {
    builder;
    constructor(builder) {
        this.builder = builder;
    }
    buildSelect(table, columns, condition) {
        this.builder.reset();
        this.builder.setSelect();
        this.builder.setTable(table);
        this.builder.setColumns(columns);
        if (condition) {
            this.builder.setWhere(condition);
        }
    }
    buildUpdate(table, assignments, condition) {
        this.builder.reset();
        this.builder.setUpdate();
        this.builder.setTable(table);
        this.builder.setAssignments(assignments);
        if (condition) {
            this.builder.setWhere(condition);
        }
    }
    buildDelete(table, condition) {
        this.builder.reset();
        this.builder.setDelete();
        this.builder.setTable(table);
        if (condition) {
            this.builder.setWhere(condition);
        }
    }
    buildInsert(table, columns, values) {
        this.builder.reset();
        this.builder.setInsert();
        this.builder.setTable(table);
        this.builder.setColumns(columns);
        this.builder.setValues(values);
    }
}
// 5. Client : crée le builder, crée le directeur, lance la construction
// Exemple d'utilisation "SELECT"
const builderConcrete = new StandardSqlQueryBuilder();
const director = new SqlQueryDirector(builderConcrete);
director.buildSelect("users", ["id", "name"], "age > 30");
const sqlQuery = builderConcrete.getResult();
console.log(sqlQuery.getSql()); // Affiche : SELECT id, name FROM users WHERE age > 30
// Exemple d'utilisation "UPDATE"
director.buildUpdate("users", ["name = 'John Doe'"], "id = 1");
const updateQuery = builderConcrete.getResult();
console.log(updateQuery.getSql()); // Affiche : UPDATE users SET name = 'John Doe' WHERE id = 1
// Exemple d'utilisation "DELETE"
director.buildDelete("users", "id = 1");
const deleteQuery = builderConcrete.getResult();
console.log(deleteQuery.getSql()); // Affiche : DELETE FROM users WHERE id = 1
// Exemple d'utilisation "INSERT"
director.buildInsert("users", ["name", "age"], ["'Alice'", "25"]);
const insertQuery = builderConcrete.getResult();
console.log(insertQuery.getSql()); // Affiche : INSERT INTO users (name, age) VALUES ('Alice', 25)
//# sourceMappingURL=builderDirector.js.map