using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebFormApp2UserMVC.Models
{
    public class User
    {
        public int UserID { set; get; }
        public int Role { set; get; }
        public string FirstName { set; get; }
        public string PrimaryEmail { set; get; }
        public string UserName { set; get; }
        public string UniversityEmail { set; get; }
    }
}