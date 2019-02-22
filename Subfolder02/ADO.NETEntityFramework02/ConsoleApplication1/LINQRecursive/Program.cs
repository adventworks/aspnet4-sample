using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LINQRecursive
{
    class Program
    {
        public static IQueryable<Provice> Provices;
        static void Main(string[] args)
        {
            IEnumerable<Provice> provices = new Provice[] {
                new Provice { ParentItemKey="China",ItemKey="1",ItemValue="Xi'an"},
                new Provice { ParentItemKey="China",ItemKey="2",ItemValue="Bei'jing"},
                new Provice { ParentItemKey="China",ItemKey="3",ItemValue="Shang'hai"},
                new Provice { ParentItemKey="1",ItemKey="1",ItemValue="a"},
                new Provice { ParentItemKey="1",ItemKey="2",ItemValue="b"},
                new Provice { ParentItemKey="2",ItemKey="3",ItemValue="c"},
                new Provice { ParentItemKey="2",ItemKey="4",ItemValue="d"},
                new Provice { ParentItemKey="3",ItemKey="5",ItemValue="e"},
                new Provice { ParentItemKey="3",ItemKey="6",ItemValue="f"}
                //new Provice { ParentItemKey="China",ItemKey="1",ItemValue="Xi'an"},
                //new Provice { ParentItemKey="China",ItemKey="2",ItemValue="Bei'jing"},
                //new Provice { ParentItemKey="China",ItemKey="3",ItemValue="Shang'hai"},
                //new Provice { ParentItemKey="1",ItemKey="a",ItemValue="aa"},
                //new Provice { ParentItemKey="1",ItemKey="b",ItemValue="bb"},
                //new Provice { ParentItemKey="2",ItemKey="c",ItemValue="cc"},
                //new Provice { ParentItemKey="2",ItemKey="d",ItemValue="dd"},
                //new Provice { ParentItemKey="3",ItemKey="e",ItemValue="ee"},
                //new Provice { ParentItemKey="3",ItemKey="f",ItemValue="ff"},
                //new Provice { ParentItemKey="a",ItemKey="aa",ItemValue="abc"},
                //new Provice { ParentItemKey="b",ItemKey="bb",ItemValue="def"},
                //new Provice { ParentItemKey="c",ItemKey="cc",ItemValue="ghk"},
            };
            Provices = provices.AsQueryable();

            var item = Provices
                .Where(p => p.ParentItemKey == "1");
            //.Select(c=>new {
            //    ParentItemKey=c.ParentItemKey,
            //    ItemKey=c.ItemKey,
            //    ItemValue=c.ItemValue
            //}).AsQueryable();


            HieararchyWalk(item);

            //List<Provice> list = GetItemTree(item).ToList();
            Console.ReadKey();
        }
       
        

        public static void HieararchyWalk(IQueryable<Provice> parentList)
        {
            if (parentList != null)
            {
                foreach (var item in parentList)
                {
                    Console.WriteLine(string.Format("{0}       {1}", item.ItemKey, item.ItemValue));
                    var children = Provices.Where(s => parentList.Any(p => p.ItemKey == item.ParentItemKey));

                    ///var children=
                    HieararchyWalk(children);
                }
            }
        }
    }
    public class Provice
    {
        public string ParentItemKey { set; get; }
        public string ItemKey { set; get; }
        public string ItemValue { set; get; }

        public IQueryable<Provice> Children { set; get; }
    }

    #region
    //public class Comment
    //{
    //    public int Id { get; set; }
    //    public int ParentId { get; set; }
    //    public string Text { get; set; }
    //    public List<Comment> Children { get; set; }
    //}

    //class Program
    //{
    //    static void Main()
    //    {
    //        List<Comment> categories = new List<Comment>()
    //        {
    //            new Comment () { Id = 1, Text = "Item 1", ParentId = 0},
    //            new Comment() { Id = 2, Text = "Item 2", ParentId = 0 },
    //            new Comment() { Id = 3, Text = "Item 3", ParentId = 0 },
    //            new Comment() { Id = 4, Text = "Item 1.1", ParentId = 1 },
    //            new Comment() { Id = 5, Text = "Item 3.1", ParentId = 3 },
    //            new Comment() { Id = 6, Text = "Item 1.1.1", ParentId = 4 },
    //            new Comment() { Id = 7, Text = "Item 2.1", ParentId = 2 }
    //        };

    //        List<Comment> hierarchy = new List<Comment>();
    //        hierarchy = categories
    //                        .Where(c => c.ParentId == 0)
    //                        .Select(c => new Comment()
    //                        {
    //                            Id = c.Id,
    //                            Text = c.Text,
    //                            ParentId = c.ParentId,
    //                            Children = GetChildren(categories, c.Id)
    //                        })
    //                        .ToList();

    //        HieararchyWalk(hierarchy);

    //        Console.ReadLine();
    //    }

    //    public static List<Comment> GetChildren(List<Comment> comments, int parentId)
    //    {
    //        return comments
    //                .Where(c => c.ParentId == parentId)
    //                .Select(c => new Comment
    //                {
    //                    Id = c.Id,
    //                    Text = c.Text,
    //                    ParentId = c.ParentId,
    //                    Children = GetChildren(comments, c.Id)
    //                })
    //                .ToList();
    //    }

    //    public static void HieararchyWalk(List<Comment> hierarchy)
    //    {
    //        if (hierarchy != null)
    //        {
    //            foreach (var item in hierarchy)
    //            {
    //                Console.WriteLine(string.Format("{0} {1}", item.Id, item.Text));
    //                HieararchyWalk(item.Children);
    //            }
    //        }
    //    }
    //}
    #endregion
}
