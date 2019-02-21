namespace EmbedVideoWinForm
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.LabUrl = new System.Windows.Forms.Label();
            this.btnGo = new System.Windows.Forms.Button();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.webBrowser1 = new System.Windows.Forms.WebBrowser();
            this.listBox1 = new System.Windows.Forms.ListBox();
            this.btnChange = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // LabUrl
            // 
            this.LabUrl.AutoSize = true;
            this.LabUrl.Location = new System.Drawing.Point(20, 23);
            this.LabUrl.Name = "LabUrl";
            this.LabUrl.Size = new System.Drawing.Size(20, 13);
            this.LabUrl.TabIndex = 0;
            this.LabUrl.Text = "Url";
            // 
            // btnGo
            // 
            this.btnGo.Location = new System.Drawing.Point(285, 100);
            this.btnGo.Name = "btnGo";
            this.btnGo.Size = new System.Drawing.Size(47, 23);
            this.btnGo.TabIndex = 1;
            this.btnGo.Text = "Load";
            this.btnGo.UseVisualStyleBackColor = true;
            this.btnGo.Click += new System.EventHandler(this.btnLoad_Click);
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(46, 20);
            this.textBox1.Name = "textBox1";
            this.textBox1.Size = new System.Drawing.Size(69, 20);
            this.textBox1.TabIndex = 2;
            // 
            // webBrowser1
            // 
            this.webBrowser1.Location = new System.Drawing.Point(15, 44);
            this.webBrowser1.MinimumSize = new System.Drawing.Size(20, 20);
            this.webBrowser1.Name = "webBrowser1";
            this.webBrowser1.Size = new System.Drawing.Size(153, 66);
            this.webBrowser1.TabIndex = 3;
            // 
            // listBox1
            // 
            this.listBox1.FormattingEnabled = true;
            this.listBox1.Location = new System.Drawing.Point(273, 13);
            this.listBox1.Name = "listBox1";
            this.listBox1.Size = new System.Drawing.Size(169, 82);
            this.listBox1.TabIndex = 4;
            // 
            // btnChange
            // 
            this.btnChange.Location = new System.Drawing.Point(365, 100);
            this.btnChange.Name = "btnChange";
            this.btnChange.Size = new System.Drawing.Size(56, 23);
            this.btnChange.TabIndex = 5;
            this.btnChange.Text = "Change";
            this.btnChange.UseVisualStyleBackColor = true;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(465, 339);
            this.Controls.Add(this.btnChange);
            this.Controls.Add(this.listBox1);
            this.Controls.Add(this.webBrowser1);
            this.Controls.Add(this.textBox1);
            this.Controls.Add(this.btnGo);
            this.Controls.Add(this.LabUrl);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label LabUrl;
        private System.Windows.Forms.Button btnGo;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.WebBrowser webBrowser1;
        private System.Windows.Forms.ListBox listBox1;
        private System.Windows.Forms.Button btnChange;
    }
}

