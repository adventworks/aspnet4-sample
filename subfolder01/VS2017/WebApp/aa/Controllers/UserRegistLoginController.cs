using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace aa.Controllers
{
    public class UserRegistLoginController : Controller
    {
        // GET: UserRegistLogin
        public ActionResult Regist()
        {
            return View();
        }
        public void LoginIn()
        {
            Redirect("");
        }
    }
}