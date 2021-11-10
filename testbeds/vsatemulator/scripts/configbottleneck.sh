#!/bin/sh                                                                           
# conf bottle neck                                                                  
                                                                                    
case $1 in                                                                          
        ref)                                                                        
                # $ qalc 8.5Mbit/s times 600ms to kilobytes                         
                # (8.5 * (megabit / second)) * (600 * millisecond) = 637.5 kilobytes
		echo reference scenario
                ipfw pipe 1 config delay 300ms bw 1500Kbit/s                        
                ipfw pipe 2 config delay 300ms bw 8500Kbit/s queue 640KB            
                ;;                                                                  
        small)                                                                      
		echo small scenario
                ipfw pipe 1 config delay 325ms bw 2000Kbit/s queue 160KB            
                ipfw pipe 2 config delay 325ms bw 10000Kbit/s queue 810KB           
                ;;                                                                  
        medium)                                                                     
		echo medium scenario
                ipfw pipe 1 config delay 325ms bw 10000Kbit/s queue 810KB           
                ipfw pipe 2 config delay 325ms bw 50000Kbit/s queue 4062KB
                ;;                                                                  
        *)                                                                          
                echo "usage ./setupnetwork [ref|small|medium]"                      
                exit                                                                
                ;;                                                                  
esac                                                                                
