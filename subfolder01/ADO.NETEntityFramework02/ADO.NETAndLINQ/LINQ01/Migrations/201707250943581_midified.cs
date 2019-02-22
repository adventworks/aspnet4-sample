namespace LINQ01.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class midified : DbMigration
    {
        public override void Up()
        {
            CreateTable(
                "dbo.Users",
                c => new
                    {
                        User_Id = c.Int(nullable: false, identity: true),
                        UserName = c.String(),
                        Email = c.String(),
                    })
                .PrimaryKey(t => t.User_Id);
            
            DropTable("dbo.MyModels");
        }
        
        public override void Down()
        {
            CreateTable(
                "dbo.MyModels",
                c => new
                    {
                        MyModelID = c.Int(nullable: false, identity: true),
                        MyModelName = c.String(),
                        Email = c.String(),
                    })
                .PrimaryKey(t => t.MyModelID);
            
            DropTable("dbo.Users");
        }
    }
}
