require "big"
require "./**"


# !! Note that verification of National check digits is not implemented
#
# cf https://en.wikipedia.org/wiki/International_Bank_Account_Number#National_check_digits 



module Iban

  # When computing the IBAN checksum, 55 is substracted from alphabetic 
  # character codepoints.
  #
  # The codepoints for A-Z are 65-90
  #
  # After subtracting 55, the resulting range in 10-35

  DIFF = 55

  # The maximum length of an IBAN is 34 characters, constitued of:
  #
  # ISO Country code: 2a (alphabetic)
  # Checksum: 2n (numeric)
  # BBAN (Basic Bank Account Number): up to 30c (alphanumeric), country-specific
  
  MAX_LENGTH = 34

  # Norway has the shortest IBAN with 15 characters
  
  MIN_LENGTH = 15

  # Returns true if the *iban* string conforms to the ISO 13616:2007 standard,
  # false otherwise
  #

  def self.validate(iban : String) : Bool
    return true if validate_with_feedback(iban) == "OK"
    return false
  end


  # Returns "OK" if the *iban* string conforms to the ISO 13616:2007 standard.
  #
  # Returns a descriptive error message otherwise 
  #

  def self.validate_with_feedback(iban : String) : String

    # upcase and delete white spaces
    iban = iban.upcase.delete(' ')

    # check for IBAN min and max length
    return "IBAN is too short" if iban.size < MIN_LENGTH
    return "IBAN is too long" if iban.size > MAX_LENGTH
    
    # check for illegal characters
    return "IBAN contains illegal characters" unless iban =~ /([A-Z]{2})(\d{2})([0-9A-Z]*)$/
    
    country = $1
    checksum = $2
    bban = $3
    
    # check country
    return "IBAN country code not recognised" unless @@format.has_key?(country)

    # check format
    regex_string = "^"
    @@format[country].split(",").each do |fmt|
      if fmt =~ /(\d*)a/
        regex_string += "[A-Z]{#{$1}}"
      elsif fmt =~ /(\d*)c/
        regex_string += "[0-9A-Z]{#{$1}}"
      elsif fmt =~ /(\d*)n/
        regex_string += "[0-9]{#{$1}}"
      end
    end
    regex_string += "$"
    
    return "IBAN format for country #{country} incorrect" if Regex.new(regex_string).match(bban).nil?

    # Checksum
    return "IBAN checksum incorrect" if self.remainder(iban) != 1
    
    # Done
    return "OK"

  end
  

  # compute remainder
  #  

  def self.remainder(iban : String) : Int32
  
    rearranged_iban = iban[4, iban.size] + iban[0, 4]
    swapped_iban = ""
    
    # swap characters for numbers
    rearranged_iban.chars.each do |char|
      if char.ascii_letter?
        swapped_iban += (char.ord - DIFF).to_s
      else
        swapped_iban += char
      end
    end

    # convert to integer
    iban_integer = BigInt.new(swapped_iban)

    # compute remainder
    return (iban_integer % 97).to_i32
    
  end
  
  
  # format in the standard way:
  #
  # "groups of four characters separated by spaces, the last group being of variable length"
  
  def self.display(iban : String) : String
    
    iban = iban.upcase.delete(' ')
    
    res = ""    
    groups = iban.size / 4
    (0..groups).each do |i|
      res += iban[4*i..4*i+3]
      res += " "
    end
    
    return res.rstrip(" ")
  
  end
  
  
end


