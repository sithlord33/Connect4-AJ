package c4.ext;

import java.awt.Color;

import c4.base.BoardPanel;
import c4.base.C4Dialog;
import c4.base.ColorPlayer;

public privileged aspect AddOpponent {

    private ColorPlayer bluePlayer;
    private ColorPlayer redPlayer;
    private boolean turn = true;
    private BoardPanel C4Dialog.panel;
 
    public void C4Dialog.changeTurn(ColorPlayer opponent){
    	showMessage(player.name() + "'s turn");
    	player = opponent;
        repaint();
    }
    
    after(C4Dialog d) returning(BoardPanel b):
    	call(BoardPanel.new(..)) && this(d){
    	d.panel = b;
    }

    pointcut addOpponent(C4Dialog d):
    	call(void C4Dialog.configureUI()) && this(d);
    
    before(C4Dialog d): addOpponent(d){
    	bluePlayer = d.player;
    	redPlayer = new ColorPlayer("Red", Color.RED);
    }
    
    pointcut makeMove(C4Dialog d):
    	execution(void C4Dialog.makeMove(int)) && this(d);
    
    before(C4Dialog d): makeMove(d){
    	if (turn){
    		d.panel.setDropColor(d.player.color());
    		d.changeTurn(bluePlayer);
    	}
    	else {
    		d.panel.setDropColor(d.player.color());
    		d.changeTurn(redPlayer);
    		//BoardPanel.drawDroppableCheckers(g);
    	}
    	turn = !turn;
    }

    pointcut newGame(C4Dialog d):
    	call(void C4Dialog.startNewGame()) && this(d);
    
    after(C4Dialog d): newGame(d){
    	d.player = new ColorPlayer("Blue", Color.BLUE);
    	d.showMessage(d.player.name() + "'s turn");
    	d.panel.setDropColor(d.player.color());
    	turn = true;
    }
}