using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace App3
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //try
            //{
            //    using (IDbConnection db = new SqlConnection(ConfigurationManager.ConnectionStrings["cn"].ConnectionString))
            //        if (db.State == ConnectionState.Closed)
            //            db.Open();

            //    studentBindingSource.DataSource = db.Query<Student>("Select * from Students", commandType: CommandType.Text);
            //    pContainer.Enabled = false;
            //    Student obj = studentBindingSource.Current as Student;

            //    if (obj != null)
            //    {
            //        if (!string.IsNullOrEmpty(obj.ImageUrl))
            //            pic.Image = Image.FromFile(obj.ImageUrl);
            //    }

            //}
            //catch (Exception ex)
            //{

            //    MetroFramework.MetroMessageBox.Show(this, ex.Message, "Message", MessageBoxButtons.OK, MessageBoxIcon.Error);

            //}

        }

        private void btnBrowse_Click(object sender, EventArgs e)
        {
            //using (OpenFileDialog ofd = new OpenFileDialog() { Filter = "JPEG|*.jpg|PNG|*.png", ValidateNames = true })
            //{
            //    if (ofd.ShowDialog() == DialogResult.OK)
            //    {
            //        pic.Image = Image.FromFile(ofd.FileName);
            //        Student obj = studentBindingSource.Current as Student;
            //        if (obj != null)
            //            obj.ImageUrl = ofd.FileName;
            //    }
            //}
        }
        //void ClearInput()
        //{
        //    txtFullName.Text = null;
        //    txtEmail.Text = null;
        //    txtAddress.Text = null;
        //    chkGender.Checked = false;
        //    txtBirthday.Text = null;
        //    pic.Image = null;

        //}
    }
    public class Student
    {
        public void Test()
        {
            
        }
    }
}
