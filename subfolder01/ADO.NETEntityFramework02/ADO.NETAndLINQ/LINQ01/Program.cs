using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Data.Entity;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LINQ01
{
    class Program
    {
        static void Main(string[] args)
        {
            using (MyDbContext db = new MyDbContext())
            {
                // Create and save a new Blog 
                //Console.Write("Enter a name and an email: ");
                //string readline = Console.ReadLine();
                //var arr = readline.Split(' ');

                var model1 = new Role { User_Id=1, UserName = "Velen", Email = "veleny@wicresoft.com" };
                var model2 = new Role { User_Id = 2, UserName = "Aaron", Email = "aaronw@wicresoft.com" };
                db.Roles.Add(model1);
                db.Roles.Add(model2);

                db.SaveChanges();

                // Display all Blogs from the database 
                var Roles = from b in db.Roles

                            select b;
                int OldUserId = 2;

                var model = Roles.Where(f => f.User_Id.Equals(OldUserId)).ToList();
                foreach (var item in model)
                {
                    Console.WriteLine(item.User_Id + ":" + item.UserName + ":" + item.Email);
                }
                Console.WriteLine("***************************");
                int NewUserId = 1;
                model.ForEach(f => f.User_Id = NewUserId);
                foreach (var item in model)
                {
                    Console.WriteLine(item.User_Id+":"+item.UserName+":"+item.Email);
                }

                db.SaveChanges();
                Console.ReadKey();
            }
        }
    }
    public class Role
    {
        //[Key]
        public int RoleId { get; set; }
        public int User_Id { set; get; }
        public string UserName { set; get; }
        public string Email { set; get; }
    }
    public class MyDbContext : DbContext
    {
        public DbSet<Role> Roles { set; get; }
    }
}
