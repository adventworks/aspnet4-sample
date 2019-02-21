namespace LINQ01.Migrations
{
    using System;
    using System.Data.Entity.Migrations;
    
    public partial class InitialCreate : DbMigration
    {
        public override void Up()
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
            
        }
        
        public override void Down()
        {
            DropTable("dbo.MyModels");
        }
    }
}
