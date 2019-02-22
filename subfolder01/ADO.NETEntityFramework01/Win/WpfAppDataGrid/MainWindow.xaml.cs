using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WpfAppDataGrid
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            Dictionary<string, List<Instance>> dicInstances = new Dictionary<string, List<Instance>>();
            dicInstances.Add("list1", new List<Instance> { new Instance {InstanceId="1", InstanceName="Tom" }, new Instance {InstanceId= "2", InstanceName="jack" } });
            dicInstances.Add("list2", new List<Instance> { new Instance { InstanceId = "3", InstanceName = "Helon" }, new Instance { InstanceId = "4", InstanceName = "Velen" } });
            //dicInstances.Add("list1", new List<Instance> { new Instance("123", "456") }); //{ InstanceId = "3", InstanceName = "Helon" }, new Instance { InstanceId = "4", InstanceName = "Velen" } });

            Resources["List1"] = dicInstances["list1"];// convert a specific object 

            //List<Object> mylist = new List<Object>(){
            //                      new {FirstName="myfirstName1", LastName="mylastName1", Phone="+123-123-123"},
            //                      new {FirstName="myfirstName2", LastName="mylastName2", Phone="+124-124-124"},
            //                      new {FirstName="myfirstName3", LastName="mylastName3", Phone="+125-125-125"}
            //                         };
            //this.MyDataGrid.ItemsSource = mylist;
            //Resources["Objects"] = mylist;
            InitializeComponent();

            //Instance instance = new Instance("1","123");

        }
    }
    public class Instance
    {
        //private string InstanceId;// { set; get; }
        //private string InstanceName;// { set; get; }
        //public Instance(string InstanceId, string InstaceName)
        //{
        //    this.InstanceId = InstanceId;
        //    this.InstanceName = InstaceName;
        //}
        public string InstanceId { set; get; }
        public string InstanceName{ set; get; }
    }

}
