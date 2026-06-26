class DatabaseConnection {
    private static instance: DatabaseConnection;
    private connectionString: string;
    private connected: boolean = false;

    private constructor() {
        this.connectionString = "postgresql://localhost:5432/mydb";
    }

    public static getInstance(): DatabaseConnection {
        if (!DatabaseConnection.instance) {
            DatabaseConnection.instance = new DatabaseConnection();
        }

        return DatabaseConnection.instance;
    }

    public connect(): void {
        if (!this.connected) {
            this.connected = true;
            console.log(`Connecté à : ${this.connectionString}`);
        } else {
            console.log("Connexion déjà établie.");
        }
    }

    public getStatus(): string {
        return this.connected ? "Connecté" : "Déconnecté";
    }
}

const db1 = DatabaseConnection.getInstance();
const db2 = DatabaseConnection.getInstance();

db1.connect();
db2.connect();

console.log("Même instance ?", db1 === db2);
console.log("Statut :", db1.getStatus());
