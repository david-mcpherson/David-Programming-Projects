using System;
using System.Windows;

/* QUESTIONS FOR NEXT MEETING:
 * 
 * Should we have a scoreboard?
 * Should we add sound when pressing buttons?
 * Should the ai make its move instantly? Pause/no pause?
 * Colour the background?
 */
namespace Tic_Tac_Toe
{
    public partial class MainWindow : Window
    {
        public bool gameOn = true;
        public bool lastStartAI = false;
        public int wins = 0;
        public int losses = 0;
        public int draws = 0;

        public MainWindow()
        {
            InitializeComponent();
        }

        private void EndGame(string L)
        {
            gameOn = false;
            if (L == "X" && status.Content.ToString() == "Your turn.")
            {
                status.Content = "You Win!";
                wins++;
                win.Content = wins.ToString();
            }
            else if (status.Content.ToString() == "Your turn.")
            {
                status.Content = "You Lose!";
                losses++;
                loss.Content = losses.ToString();
            }
        }

        private void CheckWin(bool ai = false)
        {
            string n1 = b1.Content.ToString();
            string n2 = b2.Content.ToString();
            string n3 = b3.Content.ToString();
            string n4 = b4.Content.ToString();
            string n5 = b5.Content.ToString();
            string n6 = b6.Content.ToString();
            string n7 = b7.Content.ToString();
            string n8 = b8.Content.ToString();
            string n9 = b9.Content.ToString();

            string L;
            if (ai == true)
                L = "O";
            else L = "X";
            if (n1 == L && n2 == L && n3 == L)
                EndGame(L);
            if (n4 == L && n5 == L && n6 == L)
                EndGame(L);
            if (n7 == L && n8 == L && n9 == L)
                EndGame(L);
            if (n1 == L && n4 == L && n7 == L)
                EndGame(L);
            if (n2 == L && n5 == L && n8 == L)
                EndGame(L);
            if (n3 == L && n6 == L && n9 == L)
                EndGame(L);
            if (n1 == L && n5 == L && n9 == L)
                EndGame(L);
            if (n3 == L && n5 == L && n7 == L)
                EndGame(L);
            if (ai == false)
                    CheckWin(true);
        }

        private int WinningMove(bool ai = false)
        {
            string n1 = b1.Content.ToString();
            string n2 = b2.Content.ToString();
            string n3 = b3.Content.ToString();
            string n4 = b4.Content.ToString();
            string n5 = b5.Content.ToString();
            string n6 = b6.Content.ToString();
            string n7 = b7.Content.ToString();
            string n8 = b8.Content.ToString();
            string n9 = b9.Content.ToString();

            string L;
            if (ai == true)
                L = "O";
            else L = "X"; 
            if ((n2 == L && n3 == L || n4 == L && n7 == L || n5 == L && n9 == L) && n1 == "")
                return 1;
            if ((n1 == L && n3 == L || n5 == L && n8 == L) && n2 == "")
                return 2;
            if ((n1 == L && n2 == L || n5 == L && n7 == L || n6 == L && n9 == L) && n3 == "")
                return 3;
            if ((n1 == L && n7 == L || n5 == L && n6 == L) && n4 == "")
                return 4;
            if ((n1 == L && n9 == L || n2 == L && n8 == L || n3 == L && n7 == L || n4 == L && n6 == L) && n5 == "")
                return 5;
            if ((n3 == L && n9 == L || n4 == L && n5 == L) && n6 == "")
                return 6;
            if ((n1 == L && n4 == L || n3 == L && n5 == L || n8 == L && n9 == L) && n7 == "")
                return 7;
            if ((n2 == L && n5 == L || n7 == L && n9 == L) && n8 == "")
                return 8;
            if ((n1 == L && n5 == L || n3 == L && n6 == L || n7 == L && n8 == L) && n9 == "")
                return 9;
            return 10;
        }

        private string Play(int b, bool ai = false)
        {
            if (gameOn == false)
                    return null;
            if (ai == false)
                return "X";
            else return "O";
        }

        private void AI_Click(int n, bool overflow = false)
        {   /* # Here's what I would have done in python:
             * 
                s = 'b' + str(n) + '.get() == "     "'
                if eval(s) == True:
                    str y = 'b' + str(n) + ' = " O "'
                    exec(y)
             * 
             * # These four lines are much cooler than the switch/case mess below.
             */
            if (gameOn == false)
                return;
            switch (n)
            {
                case 1: if (b1.Content.ToString() == "") b1.Content = Play(1, true); else AI_Click(2, overflow); break;
                case 2: if (b2.Content.ToString() == "") b2.Content = Play(2, true); else AI_Click(3, overflow); break;
                case 3: if (b3.Content.ToString() == "") b3.Content = Play(3, true); else AI_Click(4, overflow); break;
                case 4: if (b4.Content.ToString() == "") b4.Content = Play(4, true); else AI_Click(5, overflow); break;
                case 5: if (b5.Content.ToString() == "") b5.Content = Play(5, true); else AI_Click(6, overflow); break;
                case 6: if (b6.Content.ToString() == "") b6.Content = Play(6, true); else AI_Click(7, overflow); break;
                case 7: if (b7.Content.ToString() == "") b7.Content = Play(7, true); else AI_Click(8, overflow); break;
                case 8: if (b8.Content.ToString() == "") b8.Content = Play(8, true); else AI_Click(9, overflow); break;
                case 9: if (b9.Content.ToString() == "") b9.Content = Play(9, true);
                    else
                    {
                        if (overflow == false)
                        {
                            AI_Click(1, true);
                        }
                        else 
                        { 
                            status.Content = "Draw.";
                            draws++;
                            draw.Content = draws.ToString();
                            gameOn = false;
                        }
                    }
                    break;
            }
        }

        private void CheckDraw()
        {
            if (b1.Content.ToString() != "" &&
                b2.Content.ToString() != "" &&
                b3.Content.ToString() != "" &&
                b4.Content.ToString() != "" &&
                b5.Content.ToString() != "" &&
                b6.Content.ToString() != "" &&
                b7.Content.ToString() != "" &&
                b8.Content.ToString() != "" && 
                b9.Content.ToString() != "" &&
                status.Content.ToString() == "Your turn.")
            {
                status.Content = "Draw.";
                draws++;
                draw.Content = draws.ToString();
            }
        }

        private void AI_Turn()
        {
            int x;
            if (gameOn == false)
                return;
            CheckWin();
            x = WinningMove(true);
            if (x == 10)
                x = WinningMove();
            if (x == 10)
            {
                Random ran = new Random();
                x = ran.Next(1, 9);
            }
            AI_Click(x);
            CheckWin();
            CheckDraw();
        }

        private void B1_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b1.Content.ToString() != "")
                return;
            b1.Content = Play(1);
            AI_Turn();
        }
       
        private void B2_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b2.Content.ToString() != "")
                return;
            b2.Content = Play(2);
            AI_Turn();
        }

        private void B3_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b3.Content.ToString() != "")
                return;
            b3.Content = Play(3);
            AI_Turn();
        }

        private void B4_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b4.Content.ToString() != "")
                return;
            b4.Content = Play(4);
            AI_Turn();
        }

        private void B5_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b5.Content.ToString() != "")
                return;
            b5.Content = Play(5);
            AI_Turn();
        }

        private void B6_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b6.Content.ToString() != "")
                return;
            b6.Content = Play(6);
            AI_Turn();
        }

        private void B7_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b7.Content.ToString() != "")
                return;
            b7.Content = Play(7);
            AI_Turn();
        }

        private void B8_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b8.Content.ToString() != "")
                return;
            b8.Content = Play(8);
            AI_Turn();
        }

        private void B9_Click(object sender, RoutedEventArgs e)
        {
            if (gameOn == false || b9.Content.ToString() != "")
                return;
            b9.Content = Play(9);
            AI_Turn();
        }

        private void Reset_Click(object sender, RoutedEventArgs e)
        {
            //if (gameOn == true)
                //return;
            b1.Content = "";
            b2.Content = "";
            b3.Content = "";
            b4.Content = "";
            b5.Content = "";
            b6.Content = "";
            b7.Content = "";
            b8.Content = "";
            b9.Content = "";
            gameOn = true;
            if (lastStartAI == false)
            {
                AI_Turn();
                lastStartAI = true;
            }
            else lastStartAI = false;
            status.Content = "Your turn.";
        }
    }
}
