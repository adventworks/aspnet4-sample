Public Class Form1
    Dim list1 As New List(Of String) From {"1", "2", "3"}
    Dim list2 As New List(Of String) From {"4", "5", "6"}
    Dim lbx As New ListBox

    Private Sub Button1_Click(sender As Object, e As EventArgs) Handles Button1.Click
        RemoveHandler ListBox1.SelectedIndexChanged, AddressOf ListBox1_SelectedIndexChanged
        'ListBox1.SelectionMode = SelectionMode.None
        ListBox1.DataSource = list2
        'ListBox1.SelectionMode = SelectionMode.One
        AddHandler ListBox1.SelectedIndexChanged, AddressOf ListBox1_SelectedIndexChanged
        'ListBox1.SelectedIndexChanged = ListBox1_SelectedIndexChanged()
    End Sub
    Private Sub Button2_Click(sender As Object, e As EventArgs) Handles Button2.Click
        ListBox1.SelectionMode = SelectionMode.None
        ListBox1.DataSource = list1
        ListBox1.SelectionMode = SelectionMode.One
    End Sub
    Private Sub Form1_Load(sender As Object, e As EventArgs) Handles MyBase.Load
        ListBox1.SelectionMode = SelectionMode.None
        ListBox1.DataSource = list1
        ListBox1.SelectionMode = SelectionMode.One
    End Sub
    Private Sub ListBox1_SelectedIndexChanged(sender As Object, e As EventArgs) Handles ListBox1.SelectedIndexChanged
        Stop
    End Sub
End Class