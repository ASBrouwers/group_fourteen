SELECT CourseName AS CourseName, Grade AS grade FROM StudentRegistrationsToDegrees, CourseRegistrations, CourseOffers, Courses WHERE StudentRegistrationsToDegrees.StudentId = %1% AND StudentRegistrationsToDegrees.DegreeId = %2% AND StudentRegistrationsToDegrees.StudentRegistrationId = CourseRegistrations.StudentRegistrationId AND CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId AND CourseOffers.CourseId = Courses.CourseId AND CourseRegistrations.Grade IS NOT NULL AND CourseRegistrations.Grade >= 5.0 ORDER BY CourseOffers.Year, CourseOffers.Quartile, CourseOffers.CourseOfferId;
SELECT DISTINCT StudentRegistrationsToDegrees.StudentId FROM StudentRegistrationsToDegrees INNER JOIN GPAAndECTSCount on (StudentRegistrationsToDegrees.StudentRegistrationId = GPAAndECTSCount.StudentRegistrationId) INNER JOIN CourseRegistrations on (GPAAndECTSCount.StudentRegistrationId = CourseRegistrations.StudentRegistrationId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) WHERE (GPAAndECTSCount.TotalECTSAcquired >= Degrees.TotalECTS AND CourseRegistrations.Grade >= 5.0 AND GPAAndECTSCount.GPA > %1%);
SELECT Degrees.DegreeId, (cast(SUM(CASE WHEN Students.Gender = 'F' THEN 1 ELSE 0 END) as float) / COUNT(Students.Gender)) as percentage FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) GROUP BY Degrees.DegreeId;
SELECT (cast(SUM(CASE WHEN Students.Gender = 'F' THEN 1 ELSE 0 END) as float) / COUNT(Students.Gender)) as percentage FROM Students INNER JOIN StudentRegistrationsToDegrees on (Students.StudentId = StudentRegistrationsToDegrees.StudentId) INNER JOIN Degrees on (StudentRegistrationsToDegrees.DegreeId = Degrees.DegreeId) WHERE (Degrees.Dept = %1%);
SELECT Courses.CourseId, CAST(COUNT(CASE WHEN Grade >= %1% THEN 1 END) AS FLOAT) / COUNT(Grade) AS percentagePassing FROM CourseRegistrations INNER JOIN CourseOffers ON (CourseRegistrations.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses ON (CourseOffers.CourseId = Courses.CourseId) WHERE Grade IS NOT NULL GROUP BY Courses.CourseId;
SELECT studentid, nrOfExcellentCourses AS numberOfCourseswhereExcellent FROM (SELECT StudentId, COUNT(CASE WHEN CourseRegistrations.Grade = MaxGrades.MaxGrade THEN 1 END) AS NrOfExcellentCourses FROM CourseRegistrations INNER JOIN MaxGrades ON (CourseRegistrations.CourseOfferId = MaxGrades.CourseOfferId) INNER JOIN StudentRegistrationsToDegrees ON (CourseRegistrations.StudentRegistrationId = StudentRegistrationsToDegrees.StudentRegistrationId) GROUP BY StudentId) AS s WHERE nrOfExcellentCourses >= %1%;
SELECT ActiveStudents.DegreeId, ActiveStudents.BirthyearStudent AS birthyear, ActiveStudents.Gender, GPAAndECTSCount.GPA AS avgGrade FROM ActiveStudents, GPAAndECTSCount WHERE ActiveStudents.StudentRegistrationId = GPAAndECTSCount.StudentRegistrationId GROUP BY CUBE(ActiveStudents.DegreeId, ActiveStudents.BirthyearStudent, ActiveStudents.Gender, GPAAndECTSCount.GPA);
SELECT CourseName, Year, Quartile FROM (SELECT CourseName, Year, Quartile, COALESCE(nrAssistants, 0) AS nrAssistants, nrStudents FROM (SELECT CourseOfferId, COUNT(StudentRegistrationId) AS nrStudents FROM CourseRegistrations GROUP BY CourseOfferId) t1 LEFT JOIN (SELECT CourseOfferId, COUNT(StudentRegistrationId) AS nrAssistants FROM StudentAssistants GROUP BY CourseOfferId) t2 ON (t1.CourseOfferId = t2.CourseOfferId) INNER JOIN CourseOffers ON (t1.CourseOfferId = CourseOffers.CourseOfferId) INNER JOIN Courses ON (CourseOffers.CourseId = Courses.CourseId)) s WHERE nrStudents / 50 > nrAssistants;