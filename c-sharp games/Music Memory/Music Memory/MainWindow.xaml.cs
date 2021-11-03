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

namespace Music_Memory
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        string rStr;
        string uStr;
        int nLevel;

        public MainWindow()
        {
            InitializeComponent();
            rStr = "";
            uStr = "";
        }

        private void Play(int i, bool auto = false)
        {
            int f = 440;
            switch (i)
            {
                case 1: f = 262; break;
                case 2: f = 294; break;
                case 3: f = 330; break;
                case 4: f = 349; break;
                case 5: f = 392; break;
                case 6: f = 440; break;
                case 7: f = 494; break;
                case 8: f = 524; break;
            }
            Console.Beep(f, 400);
            if (auto == false)
            {
                uStr += i.ToString();
            }
            if (uStr.Length == nLevel)
            {
                LevelUp();
            }
        }

        private void Recording()
        {
            int n = rStr.Length;
            int k = 0;
            while (k < n)
            {
                int x = int.Parse(rStr[k].ToString());
                Play(x, true);
                k++;
            }
        }
            
        private void B1_Click(object sender, RoutedEventArgs e)
        {
            Play(1);
        }

        private void B2_Click(object sender, RoutedEventArgs e)
        {
            Play(2);
        }

        private void B3_Click(object sender, RoutedEventArgs e)
        {
            Play(3);
        }

        private void B4_Click(object sender, RoutedEventArgs e)
        {
            Play(4);
        }

        private void B5_Click(object sender, RoutedEventArgs e)
        {
            Play(5);
        }

        private void B6_Click(object sender, RoutedEventArgs e)
        {
            Play(6);
        }

        private void B7_Click(object sender, RoutedEventArgs e)
        {
            Play(7);
        }

        private void B8_Click(object sender, RoutedEventArgs e)
        {
            Play(8);

        }

        private void LevelUp()
        {
            if (uStr == rStr)
            {
                note1.Content = "";
                nLevel++;
                System.Threading.Thread.Sleep(1000);
                levelNo.Content = nLevel.ToString();
                Random rInt = new Random();
                int r = rInt.Next(1, 8);
                rStr += r.ToString();
                uStr = "";
                Recording();
            }
            else
            {
                note1.Content = "Game Over!";
            }
        }

        private void Restart_Click(object sender, RoutedEventArgs e)
        {
            nLevel = 1;
            levelNo.Content = nLevel.ToString();
            note1.Content = "First Note: ";
            rStr = "";
            uStr = "";
            Random rInt = new Random();
            int r = rInt.Next(1, 8);
            rStr += r.ToString();
            note1.Content += rStr;
            Recording();
        }
    }
}
