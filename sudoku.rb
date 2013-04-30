# Programmers: 	Renaldo Pierre-Louis
# 				Eric Kosgey
# Project Desc:	This is a sudoku solver
# Date		:	2012-April

# we believe that a proper sudoku can be solved without guessing
# and this is what our program does. We have implemented rules and logic
# to help us achieve this. 
# we use this as reference www.paulspages.co.uk sudoku howtosolve

	

# / box object. A box is one of the 81 boxes on a sudoku board 
# 	@value = the value of the box
# 	@candidates = a list of possible values for that box
# 	@row = the row the box is part of
# 	@col = the collumn the box is part of
# 	@box = the 3 by 3 box that this box object is part of
# /	
class Box
	attr_accessor :value, :col, :box, :row, :candidates
	def initialize(value,  row, col, box)
		@value = value
		@candidates = Array.new
		@row = row
		@col = col
		@box = box
	end
end

# the board 
# 	@grid = the grid

class Board

	def initialize()
		@grid = Array.new

		File.open("easy.in", "r") do |infile|
		row = 1
		col = 1
		box = 1

		counting = 1;
			while (line = infile.getc)
				value = line.to_i

				# /if we reached the last collumn in a row,
				#   we reset the collumn and update the row /
				if(col > 9)
					col = 1
					row = row+1
				end
				# / developed by the brillant mathematician Eric Kosgey /
				box = (col-1)/3 + 3* ((row-1)/3) + 1;
			
				# / creating the Box oject /
				aBox = Box.new(value,row,col,box)
			   
				@grid.push(aBox)
			   
				col = col+1
			end
		end
	end

	# / this function check to see if a value exist
	#   in a given row
	#   @param value: the value to check
	#   @param row: the row number

	#   return: true if box value exist
	#           false if box value does NOT exist 
	# /
	def isInRow(value, row)
		@grid.each do |index|
			if (value == index.value && row == index.row)
				return true
			end
		end

		return false
	end


	# / this function check to see if a value exist
	#   in a given col
	#   @param value: the value to check
	#   @param col: the col number

	#   return: true if box value exist
	#           false if box value does NOT exist 
	# /
	def isInCol(value, col)
		@grid.each do |index|
			if (value == index.value && col == index.col)
				return true
			end
		end

		return false
	end


	# / this function check to see if a value exist
	#   in a given row
	#   @param value: the value to check
	#   @param box_num: the box number

	#   return: true if box value exist
	#           false if box value does NOT exist 
	# /

	def isInBox(value, box_num)
		@grid.each do |index|
			if (value == index.value && box_num == index.box)
				return true
			end
		end

		return false
	end

	# / function returns true if a value is a candidates
	#   for a box
	# /

	def isBoxCandidate(value, box_num)
		count = 0
		@grid.each do |index|
			if(box_num == index.box)
				index.candidates.each do |candidate|
					if (value == candidate)
						count = count+1
					end
					if(count > 1)
						return false
					end
				end
			end
		end
		return true
	end

	def isColCandidate(value, col)
			count = 0
			@grid.each do |index|
				if(col == index.col)
					index.candidates.each do |candidate|
						if (value == candidate)
							count = count+1
						end
						if(count > 1)
							return false
						end
					end
				end
			end
			return true
		end

	def isRowCandidate(value, row)
			count = 0
			@grid.each do |index|
				if(row == index.row)
					index.candidates.each do |candidate|
						if (value == candidate)
							count = count+1
						end
						if(count > 1)
							return false
						end
					end
				end
			end
			return true
	end


	# / this function indicates is a certain value is allowed 
	#   in a position (box)/
	def isValid(value, box)
		return !(isInBox(value, box.box) || isInCol(value, box.col) || isInRow(value, box.row))
	end

	def SingleCandidate()
		change = false
		@grid.each do |index|
			if (index.value == 0)
				index.candidates.each do |candidate|
					if(isRowCandidate(candidate, index.row))
						index.value = candidate
						change = true
						populateCandidates
					end
					if(isColCandidate(candidate, index.col))
						index.value = candidate
						change = true
						populateCandidates
					end
					if(isBoxCandidate(candidate, index.box))
						index.value = candidate
						change = true
						populateCandidates
					end
				end
			end
		end
	return change
end

	# / this function populate the list of posible candidates for a box /
	def populateCandidates()
		@grid.each do |index|
			index.candidates.clear
			if (index.value == 0)
				(1..9).each do |num|
					if (isValid(num, index))
						index.candidates.push(num)
					end	
				end
			end
		end
	end

	# / a simple variable dumb of the Board object. 
	#   can be used as debugging tool /
	def dumpBoard()
		@grid.each do |g|
			puts g.inspect
		end
	end

	# / display the board /
	def printBoard()
		col = 0
		row = 0
		@grid.each do |index|
			col = col +1
			if (index.value == 0)
				print " "
			else
				print index.value
			end

			if (col % 3 == 0 && col != 9)
				print " | "
			elsif (col == 9)
				print "\n"
				col = 0
				row = row +1
				if (row % 3 == 0 && row !=9)
					print "---------------------\n"
				end
			else
				print " "
			end
		end
	end

	# / this function makes use multiple other 
	#   functions 
	#   returns: true if it crosshatched else returns false/
	def crossHatch()
		change = false
		@grid.each do |index|
			if (index.candidates.size == 1)
				index.value = index.candidates.first
				index.candidates.pop()
				change = true
			end
		end
		return change
	end

	def pairs()
		change = false
		@grid.each do |index|
			if (index.candidates.size == 2)
				if (deleteRowCandidatesMatch(index))
					change = true
				end
				if (deleteColCandidatesMatch(index))
					change = true
				end
				if (deleteBoxCandidatesMatch(index))
					change = true
				end
			end
		end
		return change
	end

	def triples()
		change = false
		if(rowTriple)
			crossHatch
			change = true
		end
		if(colTriple)
			crossHatch
			change = true
		end
		if(boxTriple)
			crossHatch
			change = true
		end
		return change
	end

	def rowTriple()
		change = false
		@grid.each do |index|
			if (index.candidates.size == 3)
				@grid.each do |second_index|
					if(index.row == second_index.row && second_index != index && isSubset(index.candidates, second_index.candidates))
						@grid.each do |third_index|
							if(third_index.row == index.row && third_index != index && third_index != second_index && isSubset(index.candidates, third_index.candidates))
								# /delete from other stuff/
								@grid.each do |other|
									if(other.row == index.row && other != index && other != second_index && other != third_index)
									  if(other.candidates != third_index.candidates && other.candidates != second_index.candidates && other.candidates != index.candidates && other.candidates.size > 1 && other.candidates.size <= 3)
  										(0...(other.candidates).size).each do |num|
  											if(index.candidates.include?(other.candidates[num]))
  												other.candidates.delete_at(num)
  												change = true
  											end
  										end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		return change
	end

	def colTriple()
		change = false
		@grid.each do |index|
			if (index.candidates.size == 3)
				@grid.each do |second_index|
					if(index.col == second_index.col && second_index != index && isSubset(index.candidates, second_index.candidates))
						@grid.each do |third_index|
							if(third_index.col == index.col && third_index != index && third_index != second_index && isSubset(index.candidates, third_index.candidates))
								# /delete from other stuff/
								@grid.each do |other|
									if(other.col == index.col && other != index && other != second_index && other != third_index)
									  if(other.candidates != third_index.candidates && other.candidates != second_index.candidates && other.candidates != index.candidates && other.candidates.size > 1 && other.candidates.size <= 3)
  										(0...(other.candidates).size).each do |num|
  											if(index.candidates.include?(other.candidates[num]))
  												other.candidates.delete_at(num)
  												change = true
  											end
  										end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		return change
	end

	def boxTriple()
		change = false
		@grid.each do |index|
			if (index.candidates.size == 3)
				@grid.each do |second_index|
					if(index.box == second_index.box && second_index != index && isSubset(index.candidates, second_index.candidates))
						@grid.each do |third_index|
							if(third_index.box == index.box && third_index != index && third_index != second_index && isSubset(index.candidates, third_index.candidates))
								# /delete from other stuff/
								@grid.each do |other|
									if(other.box == index.box && other != index && other != second_index && other != third_index)
									  if(other.candidates != third_index.candidates && other.candidates != second_index.candidates && other.candidates != index.candidates && other.candidates.size > 1 && other.candidates.size <= 3)
  										(0...(other.candidates).size).each do |num|
  											if(index.candidates.include?(other.candidates[num]))
  												other.candidates.delete_at(num)
  												change = true
  											end
  										end
  									end
									end
								end
							end
						end
					end
				end
			end
		end
		return change
	end



	# /is array_2 a subset of array_1/
	def isSubset(array_1, array_2)
		(0...(array_2).size()).each do |num|
			if(!array_1.include?array_2[num])
				return false
			end
		end
		return true
	end

	def deleteRowCandidatesMatch(box)
		change = false
		@grid.each do |index|
			if (index != box)
				if (index.row == box.row && isSubset(index.candidates, box.candidates))
					@grid.each do |second_index|
						if (second_index.row == box.row && second_index != index && second_index != box && second_index.candidates != box.candidates)
							second_index.candidates.delete_if{|i| box.candidates.include?(i)}
							change = true
						end
					end
				end
			end
		end
		return change
	end

	def deleteColCandidatesMatch(box)
		change = false
		@grid.each do |index|
			if (index != box)
				if (index.col == box.col && isSubset(index.candidates, box.candidates))
					@grid.each do |second_index|
						if (second_index.col == box.col && second_index != index && second_index != box && second_index.candidates != box.candidates)
							second_index.candidates.delete_if{|i| box.candidates.include?(i)}
							change = true
						end
					end
				end
			end
		end
		return change
	end
	
	def deleteBoxCandidatesMatch(box)
		change = false
		@grid.each do |index|
			if (index != box)
				if (index.box == box.box && isSubset(index.candidates, box.candidates))
					@grid.each do |second_index|
						if (second_index.box == box.box && second_index != index && second_index != box && second_index.candidates != box.candidates)
							second_index.candidates.delete_if{|i| box.candidates.include?(i)}
							change = true
						end
					end
				end
			end
		end
		return change
	end

	def numberClaim()
		change = false
		@grid.each do |index|
			index.candidates.each do |candidate|
				if(isRowClaim(candidate, index))
					if(removeRowOtherBoxCandidate(candidate,index))
						change = true
					end
				end
				if(isColClaim(candidate, index))
					if (removeColOtherBoxCandidate(candidate,index))
						change = true
					end
				end
			end
		end
		return change
	end

	def isRowClaim(candidate, box)
		@grid.each do |index|
			if(index.box == box.box && (index.candidates.include?(candidate) && index.row != box.row))
				return false
			end
		end
		return true
	end

	def isColClaim(candidate, box)
		@grid.each do |index|
			if(index.box == box.box && (index.candidates.include?(candidate) && index.col != box.col))
				return false
			end
		end
		return true
	end

	# / param: value of the candidate to remove
	#   param: the box object to not change
	# /

	def removeRowOtherBoxCandidate(value, box)
		change = false
		@grid.each do |index|
			if (index.box != box.box && index.row == box.row && index.candidates.include?(value))
				index.candidates.delete(value)
				change = true
			end
		end
		return change
	end

	def removeColOtherBoxCandidate(value, box)
		change = false
		@grid.each do |index|
			if (index.box != box.box && index.col == box.col && index.candidates.include?(value))
				index.candidates.delete(value)
				change = true
			end
		end
		return change
	end


	# / are we there yet? have we solved it 
	#   returns: boolean
	# /	
	def isSolved()
		@grid.each do |index|
			if(index.value == 0)
				return false
			end
		end
		return true
	end


	# / this uses the rules /
	def solve()
		while(isSolved == false)
			while (crossHatch())
				populateCandidates()
			end
		
			while(SingleCandidate())
				while (crossHatch())
					populateCandidates()
				end
			end
			
			while (numberClaim())
				while(crossHatch)
					populateCandidates
				end
				SingleCandidate()
			end
			if(pairs())
				while(crossHatch)
					populateCandidates
				end
				SingleCandidate()
				numberClaim()
			end
			if(triples())
				while(crossHatch)
					populateCandidates
				end
				SingleCandidate()
				numberClaim()
				pairs
			end
		end
	end
end 
# /----------------END OF CLASS----------------------/


# /----------------Driver---------------/

myBoard = Board.new()
puts "Original Board"
puts ""

myBoard.printBoard()

print "\n"

myBoard.populateCandidates()
myBoard.solve()

puts "Solved Board"
puts ""

myBoard.printBoard()
# /---------------end of driver-----------/