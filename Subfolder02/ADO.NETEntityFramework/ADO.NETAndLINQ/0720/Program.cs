using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
namespace _0720
{
    class Program
    {
        
        static void Main(string[] args)
        {
            using(var db = new MyDbContext())
            {

                //db.Claims.Add(new Claim() {  Name = "123"});
                ////db.Inspections.Add(new Inspection() { InspectionID = 2, Name = "456" });
                ////db.Inspections.Add(new Inspection() { InspectionID = 3, Name = "789" });
                //db.SaveChanges();

                var entity = db.Inspections.AsNoTracking().First();

                Console.WriteLine(entity.InspectionID + ":" + entity.Name);

                Type typeParameterType = typeof(Inspection);
                db.Set<Inspection>().Attach(entity);
                
                db.Entry(Convert.ChangeType(entity, typeParameterType)).Collection("Claim").Load();
            }
           
            Console.ReadKey();
        }
    }
    public class MyDbContext : DbContext
    {
        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(@"Server=(localdb)\mssqllocaldb;user=sa;pwd=wjp1842022$;Database=FirstDatabase;Trusted_Connection=True;");
        }
        public DbSet<Claim> Claims { set; get; }
        public DbSet<Location> Locations { set; get; }
        public DbSet<Inspection> Inspections { set; get; }
    }
    public class Claim
    {
        public int ClaimID { set; get; }
        public string Name { set; get; }


        public virtual ICollection<Inspection> Inspections { get; set; }
        public virtual ICollection<Location> Locations { set; get; }
    }
    public class Location
    {
        public int LocationID { set; get; }

        public int ClaimID { set; get; }
        public virtual Claim Claim { get; set; }

        public virtual ICollection<Inspection> Inspections { get; set; }
    }
    public class Inspection
    {
        public int InspectionID { set; get; }
        public string Name { get; set; }

        public int ClaimID { set; get; }
        public int LocationID { set; get; }

        public virtual Claim Claim { get; set; }
        public virtual Location Location { set; get; }
    }
}
