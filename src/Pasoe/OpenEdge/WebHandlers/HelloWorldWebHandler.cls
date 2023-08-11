 
 /*------------------------------------------------------------------------
    File        : HelloWorldWebHandler
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Daniel
    Created     : Thu Jul 28 16:06:49 CEST 2022
    Notes       : 
  ----------------------------------------------------------------------*/

USING Progress.Lang.*.
USING OpenEdge.Web.* FROM PROPATH.
USING Progress.Json.ObjectModel.* FROM PROPATH.
USING OpenEdge.Net.HTTP.* FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

CLASS WebHandlers.HelloWorldWebHandler INHERITS WebHandler: 

 
    /*------------------------------------------------------------------------------
            Purpose: Handler for unsupported methods. The request being serviced and
                     an optional status code is returned. A zero or null value means 
                     this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD OVERRIDE PROTECTED INTEGER HandleNotAllowedMethod( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
    
        /* Throwing an error from this method results in a 500/Internal Server Error response. 
        The web handler will attempt to log this exception.
        
        See the HandleGet method's comments on choosing a value to return from this method. */
            
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    END METHOD.


    /*------------------------------------------------------------------------------
            Purpose: Handler for unknown methods. The request being serviced and an 
                     optional status code is returned. A zero or null value means 
                     this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD OVERRIDE PROTECTED INTEGER HandleNotImplemented( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
    
        /* Throwing an error from this method results in a 500/Internal Server Error response. 
        The web handler will attempt to log this exception.
        
        See the HandleGet method's comments on choosing a value to return from this method. */  
        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    END METHOD.
    
    
    /*------------------------------------------------------------------------------
            Purpose: Default handler for the HTTP GET method. The request being 
                     serviced and an optional status code is returned. A zero or 
                     null value means this method will deal with all errors.                                                               
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    METHOD OVERRIDE PROTECTED INTEGER HandleGet( INPUT poRequest AS OpenEdge.Web.IWebRequest ):
    
        DEFINE VARIABLE oJson     AS JsonObject    NO-UNDO .
        DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO .

        oJson = NEW JsonObject() .
        oJson:Add ("Message", "Hello Remote PUG USA 2023!").

        ASSIGN
            oResponse             = NEW WebResponse ()
            /* HTTP messages require a content type */
            oResponse:ContentType = 'application/json':U
            oResponse:Entity      = oJson
            .

        THIS-OBJECT:WriteResponse(oResponse).
        
        /* A response of 0 means that this handler will build the entire response;
           a non-zero value is mapped to a static handler in the webapp's /static/error folder.
           The mappings are maintained in the webapps's WEB-INF/web.xml
           A predefined set of HTTP status codes is provided in the OpenEdge.Net.HTTP.StatusCodeEnum
           enumeration */
        RETURN 0.      
            
    END METHOD. 
    
    METHOD PROTECTED VOID WriteResponse (poResponse AS IHttpResponse):

        DEFINE VARIABLE oWriter AS WebResponseWriter NO-UNDO.

        /* dump to stream */
        oWriter = NEW WebResponseWriter (poResponse).
        oWriter:Open ().
        oWriter:Close ().

    END METHOD.    


END CLASS.