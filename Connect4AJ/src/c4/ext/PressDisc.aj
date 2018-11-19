package c4.ext;

import java.awt.Graphics;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;

import c4.base.BoardPanel;

public privileged aspect PressDisc {
	
	private int BoardPanel.selected;
	private boolean BoardPanel.mustHighlight = false;
		
	pointcut MouseDisc(BoardPanel b): 
		execution(BoardPanel.new(..)) && this(b);
		
	after(BoardPanel b): MouseDisc(b){
		b.addMouseListener(new MouseAdapter() {
			@Override
			public void mousePressed(MouseEvent e) {
				b.selected = b.locateSlot(e.getX(), e.getY());
				b.mustHighlight = true;
				b.repaint();
			}
			@Override
			public void mouseReleased(MouseEvent e) {
				b.selected = b.locateSlot(e.getX(), e.getY());
				b.mustHighlight = false;
				b.repaint();
			}
		});
	}
	
	pointcut press(BoardPanel b, Graphics g):
		execution(void BoardPanel.drawDroppableCheckers(Graphics)) && this(b) && args(g);
		
	after(BoardPanel b, Graphics g): press(b, g){
		if(b.selected >= 0 && !b.board.isSlotFull(b.selected)) {
			b.drawChecker(g, b.dropColor, b.selected, -1, b.mustHighlight);
		}
	}
}