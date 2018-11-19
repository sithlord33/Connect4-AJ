import c4.model.Board;

import javax.sound.sampled.*;
import java.io.IOException;

import c4.base.C4Dialog;
import c4.model.*;

public privileged aspect AddSound {

   private static final String SOUND_DIR = "/sound/";

   public static void playAudio(String filename) {
       try {
           AudioInputStream audioIn = AudioSystem.getAudioInputStream(
                   AddSound.class.getResource(SOUND_DIR + filename));
           Clip clip = AudioSystem.getClip();
           clip.open(audioIn);
           clip.start();
       } catch (UnsupportedAudioFileException
               | IOException | LineUnavailableException e) {
           e.printStackTrace();
       }
   }

   pointcut makeMove(int slot, Player p):
           execution(int Board.dropInSlot(int , Player)) && args(slot, p);

   after(int slot, Player p): makeMove(slot, p) {
       if(p.name().equals("Blue"))
           playAudio("click.wav");
       else
           playAudio("boing.wav");
   }
   
   pointcut gameOver(C4Dialog d):	
	   execution(void C4Dialog.makeMove(int)) && this(d);
	
	after(C4Dialog d): gameOver(d){
		if(d.board.isWonBy(d.player)) {
			playAudio("applause.wav");
		}
	}
}
