using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(WebFormApp1UserLogin.Startup))]
namespace WebFormApp1UserLogin
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
