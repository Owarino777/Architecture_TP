/**********************************************/
/***** 1. Produit : la requête SQL finale *****/
/**********************************************/
class SqlQuery {
    // Représente une requête SQL construite
    private query: string;

    // Le constructeur prend la requête SQL finale
    constructor(query: string) {
        this.query = query;
    }

    // Méthode pour récupérer la requête SQL
    public getSql(): string {
        return this.query;
    }
}
/*********************************************************/
/***** 2. Interface du monteur : les étapes communes *****/
/*********************************************************/
interface SqlQueryBuilder {
    // Méthode pour réinitialiser le monteur
    reset(): void;

    // Méthodes pour définir les différentes parties de la requête
    setSelect(): void;
    setUpdate(): void;
    setDelete(): void;
    setInsert(): void;
    setTable(table: string): void;
    setColumns(columns: string[]): void;
    setValues(values: string[]): void;
    setAssignments(values: string[]): void;
    setWhere(condition: string): void;
    getResult(): SqlQuery;
}
/******************************************************************************/
/***** 3. Monteur concret : construit une requête dans un dialecte précis *****/
/******************************************************************************/
class StandardSqlQueryBuilder implements SqlQueryBuilder {
    // Attributs pour stocker les différentes parties de la requête
    private queryType: string = "";
    private table: string = "";
    private columns: string[] = [];
    private values: string[] = [];
    private assignments: string[] = [];
    private condition: string = "";

    // Le constructeur initialise le monteur
    constructor() {
        this.reset();
    }

    // Méthode pour réinitialiser le monteur
    public reset(): void {
        this.queryType = "";
        this.table = "";
        this.columns = [];
        this.values = [];
        this.assignments = [];
        this.condition = "";
    }

    // Méthodes pour définir les différentes parties de la requête
    public setSelect(): void {
        this.queryType = "SELECT";
    }

    public setUpdate(): void {
        this.queryType = "UPDATE";
    }

    public setDelete(): void {
        this.queryType = "DELETE";
    }

    public setInsert(): void {
        this.queryType = "INSERT";
    }

    public setTable(table: string): void {
        this.table = table;
    }

    public setColumns(columns: string[]): void {
        this.columns = columns;
    }

    public setValues(values: string[]): void {
        this.values = values;
    }

    public setAssignments(values: string[]): void {
        this.assignments = values;
    }

    public setWhere(condition: string): void {
        this.condition = condition;
    }

    // Méthode pour construire la requête SQL finale et la retourner
    public getResult(): SqlQuery {
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
/***************************************************************/
/***** 4. Directeur : appelle les étapes dans le bon ordre *****/
/***************************************************************/
class SqlQueryDirector {
    // Le directeur utilise un monteur pour construire la requête
    private builder: SqlQueryBuilder;

    // Le constructeur prend un monteur en paramètre
    constructor(builder: SqlQueryBuilder) {
        this.builder = builder;
    }

    // Méthodes pour construire différents types de requêtes
    public buildSelect(table: string, columns: string[], condition?: string): void {
        this.builder.reset();
        this.builder.setSelect();
        this.builder.setTable(table);
        this.builder.setColumns(columns);
        if (condition) {
            this.builder.setWhere(condition);
        }
    }

    // Méthode pour construire une requête UPDATE
    public buildUpdate(table: string, assignments: string[], condition?: string): void {
        this.builder.reset();
        this.builder.setUpdate();
        this.builder.setTable(table);
        this.builder.setAssignments(assignments);
        if (condition) {
            this.builder.setWhere(condition);
        }
    }

    // Méthode pour construire une requête DELETE
    public buildDelete(table: string, condition?: string): void {
        this.builder.reset();
        this.builder.setDelete();
        this.builder.setTable(table);
        if (condition) {
            this.builder.setWhere(condition);
        }
    }

    // Méthode pour construire une requête INSERT
    public buildInsert(table: string, columns: string[], values: string[]): void {
        this.builder.reset();
        this.builder.setInsert();
        this.builder.setTable(table);
        this.builder.setColumns(columns);
        this.builder.setValues(values);
    }
}
/*********************************************************************************/
/***** 5. Client : crée le builder, crée le directeur, lance la construction *****/
/*********************************************************************************/

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