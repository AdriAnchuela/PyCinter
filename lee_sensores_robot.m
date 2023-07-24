%a = 1:1000
b = 1:200
suma = 0
j = 0
for i = 1:1000
    med_sonar3=receive(sonar0)
    suma = suma + med_sonar3.Range_
    %a(i)=med_sonar3.Range_
    if mod(i,5)==0
        j = j+1
        b(j)=suma/5
        suma=0;
        
    end
      
end

plot(1:5, b)
