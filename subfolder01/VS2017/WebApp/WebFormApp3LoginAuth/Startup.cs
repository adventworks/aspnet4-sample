using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(WebFormApp3LoginAuth.Startup))]
namespace WebFormApp3LoginAuth
{
    public partial class Startup {
        public void Configuration(IAppBuilder app) {
            ConfigureAuth(app);
        }
    }
}
