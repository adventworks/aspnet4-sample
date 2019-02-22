using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace aa.Models
{
    public class User
    {
        public int UserID { set; get; }
        public int Role { set; get; }
        public string PrimaryEmail { set; get; }
        public string UserName { set; get; }
    }
}