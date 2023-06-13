; ----------------------------------------------------------------------------
; Object 4A - Octus (octopus badnik) from OOZ
; ----------------------------------------------------------------------------
octus_start_position = objoff_2A
; Sprite_2CA14:
Obj4A:
	moveq	#0,d0
	move.b	routine(a0),d0
	move.w	Obj4A_Index(pc,d0.w),d1
	jmp	Obj4A_Index(pc,d1.w)
; ===========================================================================
; off_2CA22:
Obj4A_Index:	offsetTable
		offsetTableEntry.w Obj4A_Init	; 0
		offsetTableEntry.w Obj4A_Main	; 2
		offsetTableEntry.w Obj4A_Angry	; 4 - unused
		offsetTableEntry.w Obj4A_Bullet	; 6
; ===========================================================================
; loc_2CA2A:
Obj4A_Bullet:
	subi_.w	#1,objoff_2C(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	jsr	(ObjectMove).l
	lea	(Ani_obj4A).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
; loc_2CA46:
Obj4A_Angry:	; Used by removed sub-object
	subq.w	#1,objoff_2C(a0)
	beq.s	+
	jmp	(DisplaySprite).l
+
	jmp	(DeleteObject).l
; ===========================================================================
; loc_2CA52:
Obj4A_Init:
	move.l	#Obj4A_MapUnc_2CBFE,mappings(a0)
	move.w	#make_art_tile(ArtTile_ArtNem_Octus,1,0),art_tile(a0)
	ori.b	#4,render_flags(a0)
	move.b	#$A,collision_flags(a0)
	move.b	#4,priority(a0)
	move.b	#$10,width_pixels(a0)
	move.b	#$B,y_radius(a0)
	move.b	#8,x_radius(a0)
	jsr	(ObjectMoveAndFall).l
	jsr	(ObjCheckFloorDist).l
	tst.w	d1
	bpl.s	+
	add.w	d1,y_pos(a0)
	move.w	#0,y_vel(a0)
	addq.b	#2,routine(a0)
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	bpl.s	+
	bchg	#0,status(a0)
+
	move.w	y_pos(a0),octus_start_position(a0)
	rts
; ===========================================================================
; loc_2CAB8:
Obj4A_Main:
	moveq	#0,d0
	move.b	routine_secondary(a0),d0
	move.w	Obj4A_Main_Index(pc,d0.w),d1
	jsr	Obj4A_Main_Index(pc,d1.w)
	lea	(Ani_obj4A).l,a1
	jsr	(AnimateSprite).l
	jmp	(MarkObjGone).l
; ===========================================================================
; off_2CAD4:
Obj4A_Main_Index: offsetTable
	offsetTableEntry.w Obj4A_WaitForCharacter	; 0
	offsetTableEntry.w Obj4A_DelayBeforeMoveUp	; 2
	offsetTableEntry.w Obj4A_MoveUp			; 4
	offsetTableEntry.w Obj4A_Hover			; 6
	offsetTableEntry.w Obj4A_MoveDown		; 8
;	offsetTableEntry.w loc_1ED94			; $A
; ===========================================================================
; loc_2CADE:
Obj4A_WaitForCharacter:
	move.w	x_pos(a0),d0
	sub.w	(MainCharacter+x_pos).w,d0
	cmpi.w	#$80,d0
	bgt.s	+	; rts
	cmpi.w	#-$80,d0
	blt.s	+	; rts
	addq.b	#2,routine_secondary(a0)
	move.b	#3,anim(a0)	; 1 in S2SW
	move.w	#$20,objoff_2C(a0)
+
	rts
; ===========================================================================
; loc_2CB04:
Obj4A_DelayBeforeMoveUp:
	subq.w	#1,objoff_2C(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	move.b	#4,anim(a0)
	move.w	#-$200,y_vel(a0)
	jmp	(ObjectMove).l
; ===========================================================================
; loc_2CB20:
Obj4A_MoveUp:
	addi.w	#$10,y_vel(a0)
	bpl.s	+
	jmp	(ObjectMove).l
; ===========================================================================
+
	addq.b	#2,routine_secondary(a0)
	move.w	#$3C,objoff_2C(a0)
	bra.w	Obj4A_FireBullet
; ===========================================================================
; loc_2CB3A:
Obj4A_Hover:
	subq.w	#1,objoff_2C(a0)
	bmi.s	+
	rts
; ---------------------------------------------------------------------------
+
	addq.b	#2,routine_secondary(a0)
	rts
; ===========================================================================
; loc_2CB48:
Obj4A_MoveDown:
	addi.w	#$10,y_vel(a0)
	move.w	y_pos(a0),d0
	cmp.w	octus_start_position(a0),d0
	bhs.s	+
	jmp	(ObjectMove).l
; ===========================================================================
+
	clr.b	routine_secondary(a0)
	clr.b	anim(a0)
	clr.w	y_vel(a0)
	move.b	#1,mapping_frame(a0)
	rts
; ===========================================================================
; loc_2CB70:
Obj4A_FireBullet:
;	subi.w	#1,objoff_2C(a0)
;	beq.w	loc_1ED8E
;	bpl.w	+
;	move.w	#$1E,objoff_2C(a0)
;	jsr	(SingleObjLoad).l
;	bne.s	loc_1ED28
;	_move.b	#ObjID_Octus,id(a1) ; load obj4A
;	move.b	#4,routine(a1)
;	move.l	#Obj4A_MapUnc_2CBFE,mappings(a1)
;	move.w	#make_art_tile(ArtTile_ArtNem_Octus,1,0),art_tile(a1)
;	move.b	#4,mapping_frame(a1)
;	move.b	#3,priority(a1)
;	move.b	#$10,width_pixels(a1)
;	move.w	x_pos(a0),x_pos(a1)
;	move.w	y_pos(a0),y_pos(a1)
;	move.w	#$1E,objoff_2C(a1)
;	move.b	render_flags(a0),render_flags(a1)
;	move.b	status(a0),status(a1)
;loc_1ED28:
	; In the Simon Wai beta, the object loads another object
	; here, which makes it look angry as it fires.
	; This object would have used Obj4A_Angry.
	jsr	(SingleObjLoad).l
	bne.s	+	; rts
	_move.b	#ObjID_Octus,id(a1) ; load obj4A
	move.b	#6,routine(a1)
	move.l	#Obj4A_MapUnc_2CBFE,mappings(a1)
	move.w	#make_art_tile(ArtTile_ArtNem_Octus,1,0),art_tile(a1)
;	move.b	#4,mapping_frame(a1)
	move.b	#4,priority(a1)
	move.b	#$10,width_pixels(a1)
	move.w	x_pos(a0),x_pos(a1)
	move.w	y_pos(a0),y_pos(a1)
	move.w	#$F,objoff_2C(a1)
	move.b	render_flags(a0),render_flags(a1)
	move.b	status(a0),status(a1)
	move.b	#2,anim(a1)
	move.b	#$98,collision_flags(a1)
	move.w	#-$200,x_vel(a1)	; -$200 = $FE00; -$580 = $FA80 in Simon Wai beta
	btst	#0,render_flags(a1)
	beq.s	+	; rts
	neg.w	x_vel(a1)
+
	rts
; ===========================================================================
;loc_1ED8E:
;	addq.b	#2,routine_secondary(a0)
;	rts
; ===========================================================================
;loc_1ED94:
;	move.w	#$FFFA,d0
;	btst	#0,render_flags(a0)
;	beq.s	+
;	neg.w	d0
;+
;	add.w	d0,x_pos(a0)
;	jmp	(MarkObjGone).l
; ===========================================================================
; animation script
; off_2CBDC:
Ani_obj4A:	offsetTable
		offsetTableEntry.w byte_2CBE6	; 0
		offsetTableEntry.w byte_2CBEA	; 1
		offsetTableEntry.w byte_2CBEF	; 2
		offsetTableEntry.w byte_2CBF4	; 3
		offsetTableEntry.w byte_2CBF8	; 4
byte_2CBE6:	dc.b  $F,  1,  0,$FF
byte_2CBEA:	dc.b   3,  1,  2,  3,$FF
byte_2CBEF:	dc.b   2,  5,  6,$FF
;	even
byte_2CBF4:	dc.b  $F,  4,$FF
;	even
byte_2CBF8:	dc.b   7,  0,  1,$FD,  1
	even
; ----------------------------------------------------------------------------
; sprite mappings
; ----------------------------------------------------------------------------
Obj4A_MapUnc_2CBFE:	BINCLUDE "mappings/sprite/obj4A.bin"