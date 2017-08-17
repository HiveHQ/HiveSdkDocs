# Errors

> On error the Hive SDK will call the  provided `errback` function with the following JSON object structure:

```js
{
    statusCode: 'emailSignupError',
    msg: 'The email address provided (m@rtin@gingr@s.ca) looks invalid - please check that your email address is correct and try again',
    data: {
        email: 'm@rtin@gingr@s.ca'
    }
}
```

> __NOTE__: Where `status` can be replaced by any of the statuses described below and data is an optional object with additional information specific to the error.

On error the Hive SDK will call the errback function provided. Below is a breakdown of the status codes and the structure of additional  with the following format:

## Statuses
### emailSignupError

> data

```js
{

}
```

Triggered when email signup fails

### emailSignupError

> data

```js
{

}
```

Triggered when email signup fails
