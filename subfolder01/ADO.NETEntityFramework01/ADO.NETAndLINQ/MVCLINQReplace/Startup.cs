using Microsoft.Owin;
using Owin;

[assembly: OwinStartupAttribute(typeof(MVCLINQReplace.Startup))]
namespace MVCLINQReplace
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
        }
    }
}
