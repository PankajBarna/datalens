// Auth middleware — verify Clerk session token
export const authenticate = (req, res, next) => {
  // TODO: Verify Clerk JWT from Authorization header
  // const token = req.headers.authorization?.split(' ')[1];
  next();
};
