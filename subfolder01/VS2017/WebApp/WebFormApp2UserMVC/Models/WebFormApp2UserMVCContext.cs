using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace WebFormApp2UserMVC.Models
{
    public class WebFormApp2UserMVCContext : DbContext
    {
        // You can add custom code to this file. Changes will not be overwritten.
        // 
        // If you want Entity Framework to drop and regenerate your database
        // automatically whenever you change your model schema, please use data migrations.
        // For more information refer to the documentation:
        // http://msdn.microsoft.com/en-us/data/jj591621.aspx
    
        public WebFormApp2UserMVCContext() : base("name=WebFormApp2UserMVCContext")
        {
        }

        public System.Data.Entity.DbSet<WebFormApp2UserMVC.Models.User> Users { get; set; }
    }
}
