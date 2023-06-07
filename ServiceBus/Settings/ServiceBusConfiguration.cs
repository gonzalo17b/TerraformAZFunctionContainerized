namespace POCAZfuncion.Settings
{
    public class ServiceBusConfiguration
    {
        public string ConnectionString { get; set; }
        public string QueueName { get; set; }

        public string ExternalConnectionString { get; set; }
        public string ExternalQueueName { get; set; }
    }
}
