global class N26DailyEmailSendScheduler Implements Schedulable {
	global void execute(SchedulableContext ctx) {
      N26DailyEmailSend emailBatch = new N26DailyEmailSend();
      database.executeBatch(emailBatch);
   } 
    
    global static String scheduleDaily(String Name){
       // Cron EXP for hourly schedule
       String CRON_EXP = '0 0 6 * * ?';
       N26DailyEmailSendScheduler sch = new N26DailyEmailSendScheduler();
       String jobId = system.schedule(Name, CRON_EXP, sch);
       return jobId;
    }
}