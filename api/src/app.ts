import express from 'express';
import 'reflect-metadata';
import router from './components';
import session from './appSession';
import requestLogger from './middlewares/requestLogger';
import errorMiddleware from './middlewares/errorMiddleware';
import notFoundMiddleware from './middlewares/notFoundMiddleware';
import meMiddleware from './middlewares/meMiddleware';
import swaggerUI from 'swagger-ui-express';
import swaggerJSDoc from 'swagger-jsdoc';

const app = express();

const options = {
    definition: {
        openapi: "3.0.0",
        info: {
            title: "REST API HEARYOURHOME",
            version: "1.0.0",
            description: "It is a simple API created for an eip project named HEARYOURHOME."
        },
        servers: [
            {
                url: "http://localhost:8000"
            }
        ],
        components: {
            securitySchemes: {
                bearerAuth: {
                    type: "http",
                    scheme: "bearer",
                    bearerFormat: "JWT"
                }
            }
        }
    },
    apis: ["**/*.ts"]
};

const specs = swaggerJSDoc(options);

app.use('/api-docs', swaggerUI.serve, swaggerUI.setup(specs));

app.use(session);
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(meMiddleware);
app.use(requestLogger);
app.set('trust proxy', true);
app.use(router);
app.use(notFoundMiddleware);
app.use(errorMiddleware);

export default app;