db = new Mongo();

admin = db.getDB("admin");
admin.createUser(
	{
		user: "db_admin",
		pwd: "123456",
		roles: [ { role: "userAdminAnyDatabase", db: "admin" } ]
	}
);


test = db.getDB("test_db");
test.createUser(
	{
		user: "test_user",
		pwd: "123456",
		roles: [ { role: "userAdmin", db: "test_db" } ]
	}
);

