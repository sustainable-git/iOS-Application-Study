# Friday Session 3 : 인스트루먼츠

<img src="01">

- Instruments
    - Tool which helps you how to profile code
    - Easy to use GUI on top of DTrace

- Dtrace
    - Lightweight C-like scripting language
    - To look
        - Disk I/O
        - Memory
        - Processes
        - Resources

<br>
 <br>

## Contents

- [Activity Monitor](#Activity-Monitor)
- [Time Profiler](#Time-Profiler)
- [Allocations](#Allocations)
- [Leaks](#Leaks)

<br>
 <br>

### Activity Monitor

<img width=480 src="02">

- Activity Monitor
    - CPU, memory, disk and network usage
    - genaral statistics

<br>
 <br>

### Time Profiler

<img width=480 src="03"> <img width=480 src="04">

- Time profiler
    - You can use to find which one takes so much time on CPU
    - Click `Call Tree` to hide system libraries
    - By `double clicking on method`, you can go into code level details


<br>
 <br>

### Allocations

<img width=480 src="05"> 

- Allocations
    - You can see how many memories are getting allocated by time

<br>
 <br>

### Leaks

<img width=480 src="06"> <img width=480 src="07">
<img width=480 src="08"> <img width=480 src="09">

- Leaks
    - You can find where the memory lick occurs
    - Use this to find reference cycle
