using System.Text.Json.Serialization;
using Microsoft.AspNetCore.OpenApi;

var builder = WebApplication.CreateBuilder(args);
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
var app = builder.Build();

app.UseSwagger();
app.UseSwaggerUI();

app.MapGet("/dapr/subscribe", () => {
    var sub = new DaprSubscription(PubsubName: "pubsub", Topic: "orders", Route: "orders");
    Console.WriteLine("Dapr pub/sub is subscribed to: " + sub);
    return Results.Json(new DaprSubscription[]{sub});
});

// Dapr subscription in /dapr/subscribe sets up this route
app.MapPost("/orders", (DaprData<Order> requestData) => {
    Console.WriteLine("Subscriber received : " + requestData.Data.OrderId);
    return Results.Ok(requestData.Data);
});

app.MapGet("/", () => "Hello World: notification!").WithName("Hello World").WithOpenApi();

app.Run();

public record DaprData<T> ([property: JsonPropertyName("data")] T Data); 
public record Order([property: JsonPropertyName("orderId")] int OrderId);
public record DaprSubscription(
  [property: JsonPropertyName("pubsubname")] string PubsubName, 
  [property: JsonPropertyName("topic")] string Topic, 
  [property: JsonPropertyName("route")] string Route);