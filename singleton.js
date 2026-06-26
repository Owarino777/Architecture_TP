"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
class DatabaseConnection {
    static instance;
    connectionString;
    connected = false;
    constructor() {
        this.connectionString = "postgresql://localhost:5432/mydb";
    }
    static getInstance() {
        if (!DatabaseConnection.instance) {
            DatabaseConnection.instance = new DatabaseConnection();
        }
        return DatabaseConnection.instance;
    }
    connect() {
        if (!this.connected) {
            this.connected = true;
            console.log(`Connecté à : ${this.connectionString}`);
        }
        else {
            console.log("Connexion déjà établie.");
        }
    }
    getStatus() {
        return this.connected ? "Connecté" : "Déconnecté";
    }
}
const db1 = DatabaseConnection.getInstance();
const db2 = DatabaseConnection.getInstance();
db1.connect();
db2.connect();
console.log("Même instance ?", db1 === db2);
console.log("Statut :", db1.getStatus());
//# sourceMappingURL=singleton.js.map