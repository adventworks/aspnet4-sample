using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace CopyFileRemote
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        [DllImport("advapi32.DLL", SetLastError = true)]
        public static extern int LogonUser(string lpszUsername, string lpszDomain, string lpszPassword, int dwLogonType, int dwLogonProvider, ref IntPtr phToken);
        private void button1_Click(object sender, EventArgs e)
        {
            IntPtr admin_token = default(IntPtr);
            WindowsIdentity wid_current = WindowsIdentity.GetCurrent();
            WindowsIdentity wid_admin = null;
            WindowsImpersonationContext wic = null;
            try
            {
                MessageBox.Show("Copying file...");
                if (LogonUser("10.168.172.146", "WangJianPing", "Pass@123", 9, 0, ref admin_token) != 0)
                {
                    wid_admin = new WindowsIdentity(admin_token);
                    wic = wid_admin.Impersonate();
                    

                    File.Copy("\\" + wid_current + @"\c$\C:\Users\v-jianpw\Desktop\Sample.txt", @"\\10.168.172.146\d$\C: \Users\WangJianPing\Desktop\Sample.txt");
                    //File.Copy(@"C:\Users\v-jianpw\Desktop", @"C:\Users\WangJianPing\Desktop\svg.txt");
                    MessageBox.Show("Copy succeeded");
                }
                else
                {
                    MessageBox.Show("Copy Failed");
                }
            }
            catch (System.Exception se)
            {
                int ret = Marshal.GetLastWin32Error();
                MessageBox.Show(ret.ToString(), "Error code: " + ret.ToString());
                MessageBox.Show(se.Message);
            }
            finally
            {
                if (wic != null)
                {
                    wic.Undo();
                }
            }
        }
    }
}
