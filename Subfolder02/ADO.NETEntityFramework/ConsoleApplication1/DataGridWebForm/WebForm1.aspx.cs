using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace DataGridWebForm
{
    public partial class WebForm1 : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            DataTable dt = new DataTable();
            dt.Clear();
            dt.Columns.Add("Name");
            dt.Columns.Add("Jobs");
            DataRow row = dt.NewRow();
            row["Name"] = "aaaa";
            row["Jobs"] = "bbbb";
            dt.Rows.Add(row);
            DataGrid myDataGrid = new DataGrid();
            myDataGrid.DataSource = dt;
            myDataGrid.BackColor = System.Drawing.Color.Blue;
            GridView1.DataSource = dt;

        }
    }
}