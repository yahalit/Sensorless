#include "CANServer.h"

/* 
* List of data types
 T_int32                        (long - 0U)                       
 T_single                       (float - 2U)
 T_int16                        (short - 4U)
 T_uint32                       (unsigned long - 8U)
 T_uint16                       (unsigned short - 12U)
 T_double                       (double - 10U)
*/

/**
 * @brief Write a value to an object in the drive's object dictionary.
 *
 * This function sets the value of a specified object entry in the drive,
 * identified by its index and subindex. The value is written with the given
 * data type, and the result of the operation is returned in @p RetVal.
 *
 * @param Index
 *        The main index of the object in the drive's object dictionary.
 *        (Typically corresponds to a 16-bit object index.)
 *
 * @param subIndex
 *        The subindex of the object entry. Use 0 for objects without subentries.
 *
 * @param value
 *        The new value to be written to the object.
 *
 * @param dataType
 *        The data type code that specifies how @p value should be interpreted.
 *        (For example, VarDataTypes.T_uint32, see list above )
 *
 * @param RetVal
 *        Pointer to a long that will receive the result of the operation.
 *        Typically used for status or error codes (0 = success, non-zero = error).
 *
 * @return
 *        Status code of the operation:
 *        - 0 on success
 *        - Non-zero error code if the write failed
 */
void SetObject2Drive(short unsigned Index , short unsigned subIndex , double value, unsigned short dataType, long * RetVal)
{
	(void)Index;
	(void)subIndex;
	(void)value; 
	*RetVal =  0;
}

/**
 * @brief Read a value from an object in the drive's object dictionary.
 *
 * This function retrieves the value of a specified object entry from the drive,
 * identified by its index and subindex. The value is returned in @p value
 * according to the specified data type. The operation status is reported in
 * @p RetVal.
 *
 * @param Index
 *        The main index of the object in the drive's object dictionary.
 *        (Typically corresponds to a 16-bit object index.)
 *
 * @param subIndex
 *        The subindex of the object entry. Use 0 for objects without subentries.
 *
 * @param dataType
 *        The data type code that specifies how the object value should be interpreted
 *         (For example, VarDataTypes.T_uint32, see list above ) 
 *
 * @param value
 *        Pointer to a double that will receive the object’s value after conversion
 *        to the requested data type.
 *
 * @param RetVal
 *        Pointer to a long that will receive the result of the operation.
 *        Typically used for status or error codes (0 = success, non-zero = error).
 *
 * @return
 *        None.
 */

void GetObjectFromDrive(short unsigned Index, short unsigned subIndex, unsigned short dataType , double* value, long* RetVal )
{
	(void)Index;
	(void)subIndex;
	*value = 0; 
	*RetVal = 0;
}

/**
 * @brief Asynchronously write a value to an object in the drive's object dictionary.
 *
 * This function initiates a write operation to the specified object entry in the drive,
 * identified by its index and subindex. Unlike SetObject2Drive(), this call does not wait
 * for the operation to complete. Instead, a tracking code is returned that can be used
 * later to correlate completion or error status.
 *
 * @param Index
 *        The main index of the object in the drive's object dictionary.
 *        (Typically corresponds to a 16-bit object index.)
 *
 * @param subIndex
 *        The subindex of the object entry. Use 0 for objects without subentries.
 *
 * @param value
 *        The new value to be written to the object.
 *
 * @param dataType
 *        The data type code that specifies how the object value should be interpreted
 *         (For example, VarDataTypes.T_uint32, see list above ) 
 *
 * @param TrackingCode
 *        Application-supplied identifier for this asynchronous write request.
 *        This code can be used to track the operation in subsequent status checks.
 *
 * @param RetVal
 *        Pointer to a long that will receive the immediate result of initiating
 *        the operation (e.g., 0 = accepted, non-zero = initiation error).
 *
 * @return
 *        None.
 */


void SetObject2DriveNoWait(short unsigned Index, short unsigned subIndex, double value, unsigned short dataType , long TrackingCode , long* RetVal )
{
	(void)Index;
	(void)subIndex;
	(void)value;
	(void)TrackingCode;
	*RetVal = 0;
}

/**
 * @brief Retrieve acknowledgment for an asynchronous write operation.
 *
 * This function checks the completion status of a previously initiated
 * SetObject2DriveNoWait() request, using the provided tracking code.
 * The index and subindex of the acknowledged object are also checked
 * while the result code is returned via @p RetVal.
 *
 * @param Index
 *        The main index of the acknowledged object in the drive's object dictionary.
 *
 * @param subIndex
 *        The subindex of the acknowledged object entry.
 *
 * @param dataType
 *        The data type code that specifies how the acknowledged object’s
 *         (For example, VarDataTypes.T_uint32, see list above )
 *
 * @param TrackingCode
 *        The tracking identifier previously supplied to
 *        SetObject2DriveNoWait(). Used to correlate this acknowledgment
 *        with the original request.
 *
 * @param RetVal
 *        Pointer to a long that will receive the result of the operation.
 *        Typically 0 if the write was acknowledged successfully, or a
 *        non-zero error/status code.
 *
 * @return
 *        None.
 */

void GetAcknowledgeForObject2DriveNoWait(short unsigned *Index, short unsigned *subIndex , unsigned short dataType , long TrackingCode, long* RetVal)
{
	(void)Index;
	(void)subIndex;
	(void)TrackingCode;
	*RetVal = 0;
}

/**
 * @brief Initiate an asynchronous read of an object from the drive's object dictionary.
 *
 * This function requests the value of a specified object entry in the drive,
 * identified by its index and subindex. Unlike GetObjectFromDrive(), this call
 * does not wait for the read to complete. Instead, a tracking code is provided
 * to correlate the request with a later acknowledgment or data retrieval.
 *
 * @param Index
 *        The main index of the object in the drive's object dictionary.
 *        (Typically corresponds to a 16-bit object index.)
 *
 * @param subIndex
 *        The subindex of the object entry. Use 0 for objects without subentries.
 *
 * @param TrackingCode
 *        Application-supplied identifier for this asynchronous read request.
 *        This code can be used to correlate the eventual acknowledgment
 *        or data return with the original request.
 *
 * @param RetVal
 *        Pointer to a long that will receive the immediate result of initiating
 *        the read operation (e.g., 0 = request accepted, non-zero = initiation error).
 *
 * @return
 *        None.
 */
void GetObjectFromDriveNoWait(short unsigned Index, short unsigned subIndex, long TrackingCode, long* RetVal)
{
	(void)Index;
	(void)subIndex;
	*RetVal = 0;
}

/**
 * @brief Retrieve the response for an asynchronous read request.
 *
 * This function obtains the result of a previously initiated
 * GetObjectFromDriveNoWait() request, using the provided tracking code.
 * The object is identified by its index and subindex, and the data type
 * specifies how the returned value should be interpreted. The result
 * status is reported in @p RetVal.
 *
 * @param Index
 *        The main index of the object in the drive's object dictionary
 *        that was requested asynchronously.
 *
 * @param subIndex
 *        The subindex of the object entry. Use 0 for objects without subentries.
 *
 * @param dataType
 *        The data type code that specifies how the returned object’s value
*         (For example, VarDataTypes.T_uint32, see list above )
 *
 * @param TrackingCode
 *        The tracking identifier previously supplied to
 *        GetObjectFromDriveNoWait(). Used to correlate this response
 *        with the original asynchronous request.
 *
 * @param RetVal
 *        Pointer to a long that will receive the result of the operation.
 *        Typically 0 if the read completed successfully, or a non-zero
 *        error/status code if it failed.
 *
 * @return
 *        None.
 */

void GetResponseForGetObjectFromDrive(short unsigned Index, short unsigned subIndex, short unsigned dataType, long TrackingCode, long* RetVal)
{
	(void)Index;
	(void)subIndex;
	(void)dataType;
	*RetVal = 0;
}



