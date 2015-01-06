
class AOT():
	
	# Default vector for sensor constants, may be changed by user
	# Order: [Sens1, Sens2, Sens3, ... ]
	V0 = [800 , 801]
		
	@staticmethod		
	def set_calibration_constants(V0_input):
		
		AOT.V0 = []
		
		for val in V0_input:
			AOT.V0.append(val)
		
	
		
		

		
	
if __name__ == "__main__":
	
	#filename = raw_input( "Enter datafile name: " )
	filename = "DATALOG.CSV"
	
	
	for element in AOT.V0:
		print element
	
	filein = open( "Data/" + filename , "r" )
	
	
	#fileout = open( "Output/AOT-" + filename + ".CSV", "w" )
	
	
