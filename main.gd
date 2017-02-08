extends Node2D

# member variables here, example:
# var a=2
# var b="textvar"
var counter=0
var minute = 0
var bigBlocksArray = []
var lblocks = []
var selectedBlock = []
var selectedBlockColumnNumber = [0,0,0,0]
var constText = ["","","",""]
var constTextPos = [0,1,2,3]
var lastFoundedText = []
var all_history = []
var lastword0 = []
var lastword1 = []
var lastword2 = []
var lastword3 = []
var lastWords = [lastword0,lastword1,lastword2,lastword3]
var historyBlocks = []
var historyMaxYpos = 0
var MaxColumnSize = 4
var MaxColumn = [4,4,4,4]

var gessused = false
var guessCount = 0
var f = File.new()
var save_file = "user://game.data"
var saveData = [10000,1,0,80000,1,1] #TotalScore,TopGesses,TotalTime,BestTime,muzSound,efSound
var isFirstGame = false
var TopGesses = 0
var TotalTime = 0
var BestTime = 0
var tempSaveData = [1,0,0,0,1,1] #TotalScore,TopGesses,TotalTime,BestTime
var timeCounter = 0

var incorrectWordCounter = 0

var Hints = false
var HintsWord = ""

var persiaWords = [
"آ","ﺎ","آ","ﺎ",
"ا","ﺎ","ا","ﺎ",
"ب","ﺐ","ﺑ","ﺒ",
"پ","ﭗ","ﭘ","ﭙ",
"ت","ﺖ","ﺗ","ﺘ",
"ث","ﺚ","ﺛ","ﺜ",
"ج","ﺞ","ﺟ","ﺠ",
"چ","ﭻ","ﭼ","ﭽ",
"ح","ﺢ","ﺣ","ﺤ",
"خ","ﺦ","ﺧ","ﺨ",
"د","ﺪ","د","ﺪ",
"ذ","ﺬ","ذ","ﺬ",
"ر","ﺮ","ر","ﺮ",
"ز","ﺰ","ز","ﺰ",
"ژ","ﮋ","ژ","ﮋ",
"س","ﺲ","ﺳ","ﺴ",
"ش","ﺶ","ﺷ","ﺸ",
"ص","ﺺ","ﺻ","ﺼ",
"ض","ﺾ","ﺿ","ﻀ",
"ط","ﻂ","ﻃ","ﻄ",
"ظ","ﻆ","ﻇ","ﻈ",
"ع","ﻊ","ﻋ","ﻌ",
"غ","ﻎ","ﻏ","ﻐ",
"ف","ﻒ","ﻓ","ﻔ",
"ق","ﻖ","ﻗ","ﻘ",
"ک","ﮏ","ﮐ","ﮑ",
"گ","ﮓ","ﮔ","ﮕ",
"ل","ﻞ","ﻟ","ﻠ",
"م","ﻢ","ﻣ","ﻤ",
"ن","ﻦ","ﻧ","ﻨ",
"و","ﻮ","و","ﻮ",
"ه","ﻪ","ﻫ","ﻬ",
"ی","ﯽ","ﯾ","ﯿ",
"ﻻ","ﻼ","ﻻ","ﻼ"]
func save_sound():
	var muzz = 0
	var eff = 0
	if(get_node("/root/world/menu/PauseMenu/muz").get_frame()==0):
		muzz = 1
	else:
		muzz = 0
	if(get_node("/root/world/menu/PauseMenu/ef").get_frame()==0):
		eff = 1
	else:
		eff = 0
	f.open_encrypted_with_pass(save_file, File.READ,OS.get_unique_ID())
	if f.is_open(): # we opened it, let's read some data!
		tempSaveData = f.get_var()
		f.close()
	tempSaveData[4]=muzz
	tempSaveData[5]=eff
	f.open_encrypted_with_pass(save_file, File.WRITE,OS.get_unique_ID()) #TODO: handle errors and such!
	if f.is_open(): # we opened it, let's read some data!
		f.store_var(tempSaveData) # store a variable
		f.close() # data's all here, close the file

func set_ef_of(t):
	if(t):
	 	get_node("SelectSound").set_volume(0)
		 get_node("WrongWordSong").set_volume(0)
		 get_node("CorrectWordSong").set_volume(0)
		 get_node("bestWordSong").set_volume(0)
	else:
		 get_node("SelectSound").set_volume(1.2)
		 get_node("WrongWordSong").set_volume(1.2)
		 get_node("CorrectWordSong").set_volume(1.2)
		 get_node("bestWordSong").set_volume(1.2)
		

func no7(text):
	var no7s= ["آ","ا","د","ذ","ر","ز","ژ","و"]
	for i in range(8):
		if(text==no7s[i]):
			return true
	return false
func getStrTime(t):
	var s = "00"
	var m = "00"
	var tot = "00"
	if(t>=60):
		s=str(t%60)
		if(int(s)<10):
			s="0"+s
		t=t/60
		if(t>=60):
			m=str(t%60)
			if(int(m)<10):
				m="0"+m
			t=t/60
			if(t<10):
				tot = "0" + str(t)
			else:
				tot = str(t)
		else:
			if(t<10):
				m="0"+str(t)
			else:
				m=str(t)
	else:
		if(t<10):
			s="0"+str(t)
		else:
			s=str(t)

	tot = tot + ":" + m + ":" + s
	return tot
	pass
func hello():
	get_node("Label").set_text("")
	var textInvers = ""
	for i in range(selectedBlock.size()):
		bigBlocksArray[selectedBlock[i]].set_frame(0)
	selectedBlock.clear()
	if(Hints==false):
		Hints=true
		HintsWord = constText[0]
		showHints()
	pass
func showHints():
	for i in range(16):
		if(str(bigBlocksArray[i]) != '0'):
			bigBlocksArray[i].set_frame(0)
	var indexxx = 0
	if(Hints==true):
		for ijj in range(4):
			for i in range(16):
				print(i)
				if(indexxx==4):
					print("break")
					break
				if(str(bigBlocksArray[i]) != '0'):
					if(HintsWord[indexxx] == bigBlocksArray[i].get_text()):
						if(bigBlocksArray[i].get_frame() != 2):
							bigBlocksArray[i].set_frame(2)
							indexxx+=1

func _process(delta):
	var x = get_node("history").get_pos().x
	var y = get_node("history").get_pos().y
	
	if(y<=historyMaxYpos+10):
		set_process(false)
	else:
		get_node("history").set_pos(Vector2(x,((historyMaxYpos - y) * .1 + y)))
	pass

func history_button_pressed(id):
	get_node("disabler").show()
	get_node("disabler").raise()
	get_node("history").raise()
	historyMaxYpos = (lastWords[id].size()*-60)+get_node("/root").get_children()[1].get_viewport_rect().size.y-100
	var count = 0
	for i in range(lastWords[id].size()):
		for j in range(4):
			historyBlocks.append(get_node("/root/world/lblock").duplicate())
			get_node("history").add_child(historyBlocks[count])
			historyBlocks[count].set_pos(Vector2((-56*j)+195,(67*(lastWords[id].size()-i))))
			historyBlocks[count].get_node("Sprite").set_frame(lastWords[id][i][j])
			historyBlocks[count].get_node("Label").set_text(lastWords[id][i][4][j])
			count = count + 1
	
	set_process(true)
	pass

func persiaSet(end,array):
	var text = ""
	var no
	var pos
	var persia=["آ","ا","ب","پ","ت","ث","ج","چ","ح","خ","د","ذ","ر","ز","ژ","س","ش","ص","ض","ط","ظ","ع","غ","ف","ق","ک","گ","ل","م","ن","و","ه","ی"]
	for i in range(end):
		for j in range(persia.size()):
			if(persia[j]==array[i]):
				pos=j
				break
		if (i==0):
			if(i==end-1):
				no=0
			else:
				no=2
		elif(no7(array[i-1])):
			if(i!=end-1):
				no = 2
			else:
				no = 0
		else:
			if(i!=end-1):
				no = 3 
			else:
				no = 1
		text = persiaWords[(pos*4)+no]+text
	return text
	pass

func dublicate_selected_block(textArray):
	var s
	var index
	for k in range(4):
		s = BigBlock.new(get_node("big_block"))
		s.set_id (selectedBlock[k])
		for i in range(4):
			if(MaxColumn[i]<MaxColumnSize):
				MaxColumn[i]=MaxColumn[i]+1
				index = i
				break
		s.set_columnNumber(index)
		s.set_pos(Vector2((index*105)+82,(k*-50)))
		s.set_text(textArray[k])
		s.set_sleep(false)
		bigBlocksArray.remove(selectedBlock[k])
		bigBlocksArray.insert(selectedBlock[k],s)
	pass

func remove_selected_block():
	selectedBlockColumnNumber
	var tempText = ["","","",""]
	var s = 0
	for k in range(4):
		tempText[k] = bigBlocksArray[selectedBlock[k]].get_text()
		bigBlocksArray[selectedBlock[k]].remove()
		#remove_child(bigBlocksArray[selectedBlock[k]])
		bigBlocksArray.remove(selectedBlock[k])
		bigBlocksArray.insert(selectedBlock[k],s)
		#recojin max column size
		for i in range(4):
			if(selectedBlockColumnNumber[i]==k):
				MaxColumn[k]=MaxColumn[k]-1
	return tempText
	pass

func finding(textInvers):
	var tempText = remove_selected_block()
	var found = false
	if(HintsWord  == textInvers):
		Hints = false
		print("HintisDisabled")
	for i in range(constText.size()):
		if(constText[i] == textInvers ):
			found = true
			incorrectWordCounter = 0
			guessCount = guessCount+1
			get_node("/root/world/Notifi/notifi").set_frame(2)
			get_node("/root/world/Notifi").play("anim")
			get_node("/root/world/Bird/animSprite").set_frame(2)
			get_node("/root/world/Bird").play("Anim")
			get_node("/root/world/bestWordSong").play()
			lastFoundedText.append(textInvers)
			constText.remove(i)
			for j in range(4):
				lblocks[(constTextPos[i]*4)+j].get_node("Sprite").set_frame(0)
				lblocks[(constTextPos[i]*4)+j].get_node("Label").set_text(textInvers[j])
			#########
			#pp=[ligth,ligth,ligth,ligth,selecteddText]
			var pp = [0,0,0,0,textInvers]
			lastWords[constTextPos[i]].append(pp)
			#set score
			var score = int(get_node("Score").get_text())
			get_node("Score").set_text(str(score+10))
			##############
			MaxColumnSize = MaxColumnSize-1
			##########
			constTextPos.remove(i)
			break
	if(found==false):
		for i in range(lastFoundedText.size()):
			if(lastFoundedText[i]==textInvers):
				found = true
				incorrectWordCounter = 0
				guessCount = guessCount+1
				get_node("/root/world/WrongWordSong").play()
				get_node("/root/world/Notifi/notifi").set_frame(3)
				get_node("/root/world/Notifi").play("anim")
				dublicate_selected_block(tempText)
				break
	if(found==false):
		for i in range (get_node("/root/database").dataBase.size()):
			if(get_node("/root/database").dataBase[i]==textInvers):
				#set score
				var score = int(get_node("Score").get_text())
				get_node("Score").set_text(str(score+1))
				get_node("/root/world/Notifi/notifi").set_frame(1)
				get_node("/root/world/Notifi").play("anim")
				get_node("/root/world/Bird/animSprite").set_frame(1)
				get_node("/root/world/Bird").play("Anim")
				get_node("/root/world/CorrectWordSong").play()
				found = true
				incorrectWordCounter = 0
				guessCount = guessCount+1
				var max1 = 0
				var max2 = 0
				var pos = 0
				var light = [2,2,2,2,textInvers]
				var tempLight = [2,2,2,2,textInvers]
				for ii in range(constText.size()):
					var temp = ["","","",""]
					var tempPos = [0,1,2,3]
					tempLight = [2,2,2,2,textInvers]
					for j in range(4):
						 temp[j] = constText[ii][j]
					max1 = 0
					for j in range(4):
						for k in range(temp.size()):
							if(textInvers[j]==temp[k]):
								if(j==tempPos[k]):
									max1=max1+2
									tempLight[j] = 0
									
								else:
									max1=max1+1
									tempLight[j] = 1
									
								temp.remove(k)
								tempPos.remove(k)
								break
					if (max1>max2):
						max2 = max1
						pos = ii
						light =tempLight
					#temp.clear()
					#tempPos.clear()
				for ijj in range(4):
					lblocks[(constTextPos[pos]*4)+ijj].get_node("Sprite").set_frame(light[ijj])
					lblocks[(constTextPos[pos]*4)+ijj].get_node("Label").set_text(textInvers[ijj])
				lastWords[constTextPos[pos]].append(light)
				#light.clear()
				#tempLight.clear()
				#all_history[constTextPos[pos]].append(light)
				dublicate_selected_block(tempText)
				lastFoundedText.append(textInvers)
				break
	if(found==false):
		incorrectWordCounter += 1
		get_node("/root/world/WrongWordSong").play()
		dublicate_selected_block(tempText)
		get_node("/root/world/Notifi/notifi").set_frame(0)
		get_node("/root/world/Notifi").play("anim")
		get_node("/root/world/Bird/animSprite").set_frame(0)
		if(incorrectWordCounter>=3):
			get_node("/root/world/Bird").play("Anim")
	tempText.clear()
	#end of Game
	var c=0
	for i in range(16):
		if(str(bigBlocksArray[i]) == '0'):
			c +=1
	if (c==16):#get_node("/root/world").counter += 1
		print("end of game!")#TotalScore,Topguess,TotalTime,BestTime
		get_node("Timer").stop()
		get_node("TotalScore").set_text(str(int(get_node("TotalScore").get_text())+int(get_node("Score").get_text())))
		f.open_encrypted_with_pass(save_file, File.WRITE,OS.get_unique_ID()) #TODO: handle errors and such!
		saveData[0]=int(get_node("TotalScore").get_text())
		saveData[2]=TotalTime+timeCounter
		TotalTime = saveData[2]
		saveData[4] = tempSaveData[4]
		saveData[5] = tempSaveData[5]
		if (guessCount>TopGesses):
			TopGesses = guessCount
			saveData[1] = guessCount
		if(gessused == false):
			if (timeCounter<BestTime):
				BestTime = timeCounter
				saveData[3] = timeCounter
		if f.is_open(): # we opened it, let's read some data!
			f.store_var(saveData) # store a variable
			f.close() # data's all here, close the file
		get_node("/root/world/menu").set_pos(Vector2(get_node("/root/world/menu").get_pos().x,0))
		get_tree().set_pause(true)
		get_node("/root/world/menu/PauseMenu").set_pos(Vector2(-500,0))
		get_node("/root/world/menu/MainMenu").set_pos(Vector2(-500,get_node("/root/world/menu/MainMenu").get_pos().y))
		get_node("/root/world/menu/EndMenu").set_pos(Vector2(0,0))
		
		get_node("/root/world/menu/EndMenu/Time").set_text(getStrTime(timeCounter))
		get_node("/root/world/menu/EndMenu/Guesses").set_text(str(guessCount))
		get_node("/root/world/menu/EndMenu/Score").set_text(get_node("Score").get_text())
		get_node("/root/world/menu/EndMenu/TotalTime").set_text(getStrTime(TotalTime))
		get_node("/root/world/menu/EndMenu/MaxGuesses").set_text(str(TopGesses))
		if(BestTime == 80000):
			get_node("/root/world/menu/EndMenu/BestTime").set_text(getStrTime(0))
		else:
			get_node("/root/world/menu/EndMenu/BestTime").set_text(getStrTime(BestTime))
	showHints()

func full():
	get_node("Label").set_text("")
	var textInvers = ""
	for i in range(4):
		textInvers = textInvers  + bigBlocksArray[selectedBlock[i]].get_text()
		bigBlocksArray[selectedBlock[i]].set_frame(0)
	finding(textInvers)
	selectedBlock.clear()
	get_node("Label").set_text(persiaSet(4,textInvers))
	pass

class BigBlock:
	extends Node2D
	var block
	func _init(w):
		block = w.duplicate()
		w.get_node("../BlockFrame").add_child(block)
	func set_pos(pos):
		block.set_pos(pos)
	func get_pos():
		return block.get_pos()
	func set_text(text):
		block.get_node("Label").set_text(text)
	func get_text():
		return block.get_node("Label").get_text()
	func set_frame(frameNumber):
		block.get_node("sprite").set_frame(frameNumber)
	func get_frame():
		return block.get_node("sprite").get_frame()
	func remove():
		block.queue_free()
	func set_id(id):
		block.get_node("Button").id = id
	func set_columnNumber(n):
		block.get_node("Button").columnNumber = n
	func set_sleep(bo):
		block.set_sleeping(bo)
	func get_lastFrame():
		return block.get_node("Button").lastFrame


func createLblock(w):
	var count = 0
	for i in range(4):
		for j in range(4):
			lblocks.append(w.duplicate())
			add_child(lblocks[count])
			var posx = 435
			var posy = 0
			if(i>1):
				posx=205
				posy = -134
			#lblocks[count].set_pos(Vector2())#(-54*j)+posx,(67*i)+630+posy))
			#lblocks[count].set_pos(Vector2((-50*j)+posx,(67*i)+645+posy))
			lblocks[count].get_node("Sprite").set_frame(2)
			count = count + 1
	count = 0
	for i in range(2):
		for j in range(4):
			lblocks[count].set_pos(Vector2((-50*j)+435,(57*i)+625))
			count+=1
	for i in range(2):
		for j in range(4):
			lblocks[count].set_pos(Vector2((-50*j)+200.5,(57*i)+625))
			count+=1
	pass


	
class Game:
	var root
	#var time
	#var allScore
	#var thisScore
	#var bigBlocksArray = []
	var randText = [] # clear func is set
	func _init(rot):
		root = rot
	
	func create_big_blocks(b):
		for i in range(4):
			for j in range(4):
				b.append(BigBlock.new(root.get_node("big_block")))
				b[b.size()-1].set_pos(Vector2((i*105)+82,(j*111)+60))
				b[b.size()-1].set_id(b.size()-1)
				b[b.size()-1].set_columnNumber(i)
				b[b.size()-1].set_sleep(false)
		pass
	
	func set_big_blocks_random_text(b):
		for i in range(4):
			for j in range(4):
				randText.append(root.constText[i][j])
		#create randomize
		for i in range (16):     
			var random_num  = int(rand_range(0,16))
			var arrayIndex  = randText[i]
			randText[i] = randText[random_num]
			randText[random_num] = arrayIndex
		var index = 0
		for i in range(16):
				b[i].set_text(randText[i])
		randText.clear()
		pass
	
	func get_constText_random_text():
		root.constText[0] = root.get_node("/root/database").dataBase[int(rand_range(0,325))]
		root.constText[1] = root.get_node("/root/database").dataBase[int(rand_range(326,650))]
		root.constText[2] = root.get_node("/root/database").dataBase[int(rand_range(651,975))]
		root.constText[3] = root.get_node("/root/database").dataBase[int(rand_range(976,1309))]
		for i in range (4):     
			var random_num  = int(rand_range(0,4))
			var arrayIndex  = root.constText[i]
			root.constText[i] = root.constText[random_num]
			root.constText[random_num] = arrayIndex
		pass
	
	func start():
		randomize ( )
		create_big_blocks(root.bigBlocksArray)
		get_constText_random_text()
		set_big_blocks_random_text(root.bigBlocksArray)
		pass
	
	func restart():
		for i in range(16):
			if(str(root.bigBlocksArray[i])!="0"):
				root.bigBlocksArray[i].remove()
		root.bigBlocksArray.clear()
		for i in range(16):
			root.lblocks[i].get_node("Sprite").set_frame(2)
			root.lblocks[i].get_node("Label").set_text("")
		root.get_node("Label").set_text("")
		root.get_node("Score").set_text("0")
		root.get_node("tim").set_text("00:00")
		root.selectedBlock.clear()
		root.selectedBlockColumnNumber = [0,0,0,0]
		root.constText = ["","","",""]
		root.counter = 0
		root.timeCounter = 0
		root.guessCount = 0
		root.incorrectWordCounter = 0
		root.minute = 0
		root.Hints = false
		root.gessused = false
		root.HintsWord = ""
		root.get_node("Timer").start()
		root.constTextPos = [0,1,2,3]
		root.lastFoundedText.clear()
		root.all_history.clear()
		root.lastword0.clear()
		root.lastword1.clear()
		root.lastword2.clear()
		root.lastword3.clear()
		root.lastWords = [root.lastword0,root.lastword1,root.lastword2,root.lastword3]
		root.historyBlocks.clear()
		root.historyMaxYpos = 0
		root.MaxColumnSize = 4
		root.MaxColumn = [4,4,4,4]
		randomize ( ) 
		create_big_blocks(root.bigBlocksArray)
		get_constText_random_text()
		set_big_blocks_random_text(root.bigBlocksArray)
		pass
	
	func pause():
		pass
var pasy = 0
var pasTy = 0
var minnn = 0
func _input(ev):
	minnn = pasy - ev.pos.y
	if(get_node("/root/world/history").get_pos().y>710):
		get_node("/root/world/history").set_pos(Vector2(get_node("/root/world/history").get_pos().x,709))
	if(get_node("/root/world/history").get_pos().y<-600):
		get_node("/root/world/history").set_pos(Vector2(get_node("/root/world/history").get_pos().x,-599))
	if (ev.type==InputEvent.SCREEN_TOUCH):
		pasy = ev.pos.y
		pasTy = get_node("/root/world/history").get_pos().y
	elif (ev.type==InputEvent.SCREEN_DRAG):
		get_node("/root/world/history").set_pos(Vector2(get_node("/root/world/history").get_pos().x,pasTy-minnn))
		pass
func _ready():
	get_node("/root/world/Help").set_pos(Vector2(0,-1000))
	get_node("Score").set_text(str(0))
	get_node("/root/world/big_block").set_sleeping(true)
	createLblock(get_node("/root/world/lblock"))
	get_node("menu/PauseMenu").set_pos(Vector2(-500,get_node("menu/PauseMenu").get_pos().y))
	get_node("menu/EndMenu").set_pos(Vector2(-500,get_node("menu/EndMenu").get_pos().y))
	get_tree().set_pause(true)
	#save Gam
	if f.file_exists(save_file): # check if the file exists
		f.open_encrypted_with_pass(save_file, File.READ,OS.get_unique_ID())
		if f.is_open(): # we opened it, let's read some data!
			tempSaveData = f.get_var()
			get_node("TotalScore").set_text(str(tempSaveData[0])) # retrieve the gold variable
			TopGesses = tempSaveData[1]
			saveData[1] = TopGesses
			TotalTime = tempSaveData[2]
			BestTime = tempSaveData[3]
			saveData[3] = BestTime
			print("muss:" + str(tempSaveData[4]))
			print("eff:" + str(tempSaveData[5]))
			if(tempSaveData[4]==0):
				get_node("/root/world/menu/MainMenu/muz").set_frame(1)
				get_node("/root/world/menu/PauseMenu/muz").set_frame(1)
				get_node("/root/world/StreamPlayer").stop()
			else:
				get_node("/root/world/menu/MainMenu/muz").set_frame(0)
				get_node("/root/world/menu/PauseMenu/muz").set_frame(0)
				get_node("/root/world/StreamPlayer").play()
			if(tempSaveData[5]==0):
				get_node("/root/world/menu/MainMenu/ef").set_frame(1)
				get_node("/root/world/menu/PauseMenu/ef").set_frame(1)
				set_ef_of(true)
			else:
				get_node("/root/world/menu/MainMenu/ef").set_frame(0)
				get_node("/root/world/menu/PauseMenu/ef").set_frame(0)
				set_ef_of(false)
			f.close()
#		else: # failed to open the file - maybe a permission issue?
#			print("Unable to read file!")
	else: # file doesn't exist, probably set vars to some defaults, etc.
		f.open_encrypted_with_pass(save_file, File.WRITE,OS.get_unique_ID()) #TODO: handle errors and such!
		f.store_var(saveData) # store a variable
		get_node("TotalScore").set_text(str(10000))
		BestTime = 80000
		get_node("/root/world/StreamPlayer").play()
		isFirstGame = true
		get_node("/root/world/Help").set_pos(Vector2(0,0))
		get_node("/root/world/Help").raise()
		f.close() # we're done writing data, close the file